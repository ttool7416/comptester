package org.zlab.upfuzz.docker;

import org.zlab.net.tracker.Trace;
import org.zlab.ocov.tracker.ObjectGraphCoverage;
import org.zlab.upfuzz.fuzzingengine.Config;
import org.zlab.upfuzz.utils.Utilities;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.PrintWriter;
import java.net.Socket;

public abstract class Docker extends DockerMeta implements IDocker {

    public abstract void chmodDir() throws IOException, InterruptedException;

    public void restart() throws Exception {
        String[] containerRecoverCMD = new String[] {
                "docker", "compose", "restart", serviceName
        };
        Process containerRecoverProcess = Utilities.exec(
                containerRecoverCMD,
                workdir);
        containerRecoverProcess.waitFor();

        // recreate connection
        start();
        logger.info(
                String.format("Node%d restart successfully!", index));
    }

    @Override
    public ObjectGraphCoverage getFormatCoverage() throws Exception {
        // execute check inv command
        Socket socket = new Socket(networkIP,
                Config.instance.formatCoveragePort);

        ObjectInputStream in = new ObjectInputStream(socket.getInputStream());
        PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
        out.println("collect format coverage"); // send a command to the server

        ObjectGraphCoverage response = (ObjectGraphCoverage) in.readObject();
        logger.debug(
                "Received format coverage dump Id size: "
                        + response.dumpId2ObjCoverageWithContext.keySet()
                                .size());
        // clean up resources
        out.close();
        in.close();
        socket.close();
        return response;
    }

    @Override
    public void clearFormatCoverage() throws Exception {
        // execute check inv command
        Socket socket = new Socket(networkIP,
                Config.instance.formatCoveragePort);

        ObjectInputStream in = new ObjectInputStream(socket.getInputStream());
        PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
        out.println("clear"); // send a command to the server
        logger.debug("clear format coverage");
        // clean up resources
        out.close();
        in.close();
        socket.close();
    }

    @Override
    public Trace collectTrace() throws Exception {
        // execute check inv command
        Socket socket = new Socket(networkIP,
                Config.instance.formatCoveragePort);

        ObjectInputStream in = new ObjectInputStream(socket.getInputStream());
        PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
        out.println("collect trace"); // send a command to the server

        Trace response = (Trace) in.readObject();
        logger.debug(
                "Received trace = " + response);

        // clean up resources
        out.close();
        in.close();
        socket.close();
        return response;
    }
}
