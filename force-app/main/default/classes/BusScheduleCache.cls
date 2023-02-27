public class BusScheduleCache {
	private Cache.OrgPartition part;

	public BusScheduleCache(){
		part = new Cache.OrgPartition('local.BusSchedule');
	}

	public void putSchedule(String busLine, Time[] schedule){
		if (part != null){
			part.put(busLine, schedule);
		}
	}

	public Time[] getSchedule(String busLine){
		Time[] schedule = new Time[]{};
		if (part != null && (Time[])part.get(busLine) != null){
			schedule = (Time[])part.get(busLine);
		} else {
			schedule.add(Time.newInstance(8,0,0,0));
			schedule.add(Time.newInstance(17,0,0,0));
		}

		return schedule;
	}
}