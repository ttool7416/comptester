package org.zlab.upfuzz;

import java.io.Serializable;
import java.util.function.Function;

public interface SerializableFunction<T, U> extends Function, Serializable {
}
