import { Meteor } from 'meteor/meteor';

import { AppInspector } from '../cpu-profiler';

Meteor.methods({
	toggleCpuProfiler(enable, duration) {
		if (enable) {
			AppInspector.start(duration);
		} else {
			AppInspector.stop();
		}
	},
});
