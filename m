From: Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH 0/6] Remove owner field from sysfs attribute structure
Date: Wed, 28 Jul 2010 22:09:20 -0700
Message-ID: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, Richard Purdie <rpurdie@rpsys.net>, Greg Kroah-Hartman <gregkh@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul
Cc: Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>, Liam Girdwood <lrg@slimlogic.co.uk>, Mark Brown <broonie@opensource.wolfsonmicro.com>, Jani Nikula <ext-jani.1.nikula@nokia.com>, Linus Walleij <linus.walleij@stericsson.com>, Chris Wright <chrisw@sous-sol.org>, Nick Cheng <nick.cheng@areca.com.tw>, James Smart <james.smart@emulex.com>, Alex Iannicelli <alex.iannicelli@emulex.com>, "Eric W. Biederman" <ebiederm@aristanetworks.com>, Benjamin Thery <benjamin.thery@bull.net>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, Guenter Roeck <guenter.roeck@ericsson.com>
List-Id: linux-scsi@vger.kernel.org

The following comment is found in include/linux/sysfs.h:

   /* FIXME
    * The *owner field is no longer used.
    * x86 tree has been cleaned up. The owner
    * attribute is still left for other arches.
    */

As it turns out, the *owner field is (again?) initialized in several modules,
suggesting that such initialization may be creeping back into the code.

This patch set removes the above comment, the *owner field, and each instance
in the code where it was found to be initialized.

Compiled with x86 allmodconfig as well as with all alpha, arm, mips, powerpc,
and sparc defconfig builds.
