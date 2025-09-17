public with sharing class AvvikAccessController {
    public static void enqueueAvvikAccessJob(String navId) {
        String avvikAccessClassName = new DependencyInjectionRepository()
            .getApexClassByInterface('IAvvikAccess');
        if (avvikAccessClassName != null) {
            IAvvikAccess avvikAccess = (IAvvikAccess) Type.forName(
                    avvikAccessClassName
                )
                .newInstance();
            avvikAccess.setNavIdent(navId);
            System.enqueueJob(avvikAccess);
        }
    }
}
