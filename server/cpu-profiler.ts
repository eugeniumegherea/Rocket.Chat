import { writeFile as _writeFile } from 'fs';
import inspector from 'inspector';
import { resolve } from 'path';
import { promisify } from 'util';

import { ensureDirSync } from 'fs-extra';

const writeFile = promisify(_writeFile);


class PrivateAppInspector {
	private session!: inspector.Session;

	private running = false;

	async start(_duration: number, filename = new Date().toISOString()): Promise<any> {
		let duration = Math.max(5, _duration); // min 5 seconds
		duration = Math.min(duration, 300); // max 5 minutes

		if (this.running) {
			return;
		}

		this.running = true;

		return new Promise((resolvePromise, reject) => {
			try {
				this.session = new inspector.Session();
				this.session.connect();

				this.session.post('Profiler.enable', () => {
					this.session.post('Profiler.start', () => {
						console.log(`[Inspector] Profiler started for ${ duration } seconds`);
						resolvePromise();

						setTimeout(() => {
							this.session.post('Profiler.stop', async (err, { profile }) => {
								if (err) {
									reject(err);
									console.log('[Inspector] Profiler ended with error', err);
								} else {
									const filepath = `./cpu-profiles/${ filename }.cpuprofile`;
									ensureDirSync('./cpu-profiles');
									await writeFile(filepath, JSON.stringify(profile));
									console.log(`[Inspector] Profiler ended. File path: ${ resolve(filepath) }`);
								}

								this.stop();
							});
						}, duration * 1000);
					});
				});
			} catch (error) {
				reject(error);
				console.log('[Inspector] Profiler cannot start', error);

				this.stop();
			}
		});
	}

	async stop(): Promise<any> {
		try {
			if (this.session) {
				this.session.post('Profiler.disable', () => {
					this.session.disconnect();
				});
			}
		} catch (error) { /* noop */ }

		this.session = null as any;
		this.running = false;
		console.log('[Inspector] Profiler stopped');
	}
}

const instance = new PrivateAppInspector();
export {
	instance as AppInspector,
};
