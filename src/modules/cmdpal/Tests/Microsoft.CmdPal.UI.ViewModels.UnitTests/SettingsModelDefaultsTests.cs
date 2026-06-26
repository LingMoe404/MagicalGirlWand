// Copyright (c) Microsoft Corporation
// The Microsoft Corporation licenses this file to you under the MIT license.
// See the LICENSE file in the project root for more information.

using Microsoft.CmdPal.UI.ViewModels;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Microsoft.CmdPal.UI.ViewModels.UnitTests;

[TestClass]
public sealed class SettingsModelDefaultsTests
{
    [TestMethod]
    public void DefaultActivationShortcutIsAltSpace()
    {
        var hotkey = SettingsModel.DefaultActivationShortcut;

        Assert.IsFalse(hotkey.Win);
        Assert.IsFalse(hotkey.Ctrl);
        Assert.IsFalse(hotkey.Shift);
        Assert.IsTrue(hotkey.Alt);
        Assert.AreEqual(0x20, hotkey.Code);
    }
}
