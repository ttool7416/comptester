package org.zlab.upfuzz.ozone.sh.volume;

import org.zlab.upfuzz.State;
import org.zlab.upfuzz.ozone.OzoneState;
import org.zlab.upfuzz.ozone.sh.Sh;

public class DeleteVolume extends Sh {
    public DeleteVolume(OzoneState state) {
        super(state.volumePrefix);
        params.add(chooseVolume(state, this));
    }

    @Override
    public void updateState(State state) {
        String volumeName = params.get(0).toString();
        ((OzoneState) state).deleteVolume(volumeName);
    }

    @Override
    public String constructCommandString() {
        String volumeName = volumePrefix + params.get(0).toString();
        return "sh volume delete" + " " + volumeName;
    }
}
