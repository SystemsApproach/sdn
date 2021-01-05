public void createFlow(
      TrafficSelector originalSelector,
      TrafficTreatment originalTreatment,
      ConnectPoint ingress, ConnectPoint egress,
      int priority, boolean applyTreatment,
      List<Objective> objectives,
      List<DeviceId> devices) {
   TrafficSelector selector = DefaultTrafficSelector.builder(originalSelector)
      .matchInPort(ingress.port())
      .build();

   // Optionally apply the specified treatment
   TrafficTreatment.Builder treatmentBuilder;
   if (applyTreatment) {
      treatmentBuilder = DefaultTrafficTreatment.builder(originalTreatment);
   } else {
      treatmentBuilder =
      DefaultTrafficTreatment.builder();
   }

   objectives.add(DefaultNextObjective.builder()
      .withId(flowObjectiveService.allocateNextId())
      .addTreatment(treatmentBuilder.setOutput(
	  egress.port()).build())
      .withType(NextObjective.Type.SIMPLE)
      .fromApp(appId)
      .makePermanent()
      .add());
   devices.add(ingress.deviceId());

   objectives.add(DefaultForwardingObjective.builder()
      .withSelector(selector)
      .nextStep(nextObjective.id())
      .withPriority(priority)
      .fromApp(appId)
      .makePermanent()
      .withFlag(ForwardingObjective.Flag.SPECIFIC)
      .add());
   devices.add(ingress.deviceId());
}
