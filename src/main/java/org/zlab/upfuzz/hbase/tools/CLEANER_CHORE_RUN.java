package org.zlab.upfuzz.hbase.tools;

import org.zlab.upfuzz.State;
import org.zlab.upfuzz.hbase.HBaseCommand;
import org.zlab.upfuzz.hbase.HBaseState;

public class CLEANER_CHORE_RUN extends HBaseCommand {
    // read the status
    public CLEANER_CHORE_RUN(HBaseState state) {
        super(state);
    }

    @Override
    public String constructCommandString() {
        return "cleaner_chore_run";
    }

    @Override
    public void updateState(State state) {
    }
}
