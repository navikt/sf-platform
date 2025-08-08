global class SlackMessage {
    global List<Block> blocks;

    global SlackMessage(String text) {
        this.blocks = new List<Block>();
        this.blocks.add(new Block(text));
    }

    global void addSection(String text) {
        this.blocks.add(new Block(text));
    }

    private class Block {
        private Block(String text) {
            this.text = new Text(text);
        }

        private final String type = 'section';
        private Text text;
    }

    private class Text {
        private Text(String text) {
            this.text = text;
        }

        private final String type = 'mrkdwn';
        private String text;
    }
}
