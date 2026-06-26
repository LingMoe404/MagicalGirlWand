// Copyright (c) Microsoft Corporation
// The Microsoft Corporation licenses this file to you under the MIT license.
// See the LICENSE file in the project root for more information.

using Microsoft.CmdPal.Common.Services;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Microsoft.CmdPal.Common.UnitTests.Services;

[TestClass]
public sealed class ApplicationInfoServiceTests
{
    [TestMethod]
    public void UnpackagedDataDirectoriesUseMagicalGirlWandFolder()
    {
        var service = new ApplicationInfoService();

        StringAssert.Contains(service.ConfigDirectory, "MagicalGirlWand");
        StringAssert.Contains(service.CacheDirectory, "MagicalGirlWand");
        StringAssert.DoesNotMatch(service.ConfigDirectory, new("Microsoft\\.CmdPal"));
        StringAssert.DoesNotMatch(service.CacheDirectory, new("Microsoft\\.CmdPal"));
    }
}
