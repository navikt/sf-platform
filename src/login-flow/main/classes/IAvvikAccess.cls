public interface IAvvikAccess {
    void setNavIdent(String navId);
    void execute(QueueableContext context);
}
