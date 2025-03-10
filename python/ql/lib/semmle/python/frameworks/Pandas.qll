/**
 * Provides classes modeling security-relevant aspects of the `pandas` PyPI package.
 * See https://pypi.org/project/pandas/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `pandas` PyPI package.
 * See https://pypi.org/project/pandas/.
 */
private module Pandas {
  /**
   * A call to `pandas.read_pickle`
   * See https://pypi.org/project/pandas/
   * See https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_pickle.html
   */
  private class PandasReadPickleCall extends Decoding::Range, DataFlow::CallCfgNode {
    PandasReadPickleCall() {
      this = API::moduleImport("pandas").getMember("read_pickle").getACall()
    }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() {
      result in [this.getArg(0), this.getArgByName("filepath_or_buffer")]
    }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "pickle" }
  }


  private class PandasQueryCall extends CodeExecution::Range, DataFlow::CallCfgNode {
    /**
     * A call to `pandas.DataFrame.query` or `pandas.DataFrame.eval`
     * See https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.query.html
     * See https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.eval.html
     */

    PandasQueryCall() {
      this = API::moduleImport("pandas").getMember("DataFrame").getReturn().getMember(["query", "eval"]).getACall()
    }

    override DataFlow::Node getCode() { 
      result in [this.getArg(0), this.getArgByName("expr")] 
    }
  }
}