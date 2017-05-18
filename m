From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH blktests 2/3] tests/sg: add SCSI generic test grouop
Date: Thu, 18 May 2017 14:38:08 -0700
Message-ID: <20170518213808.GC26871@vader.DHCP.thefacebook.com>
References: <cover.1495109149.git.jthumshirn@suse.de>
 <b9201d03f70519230dcffd5cfa92496a3bad5da4.1495109149.git.jthumshirn@suse.de>
 <20170518210620.GA26871@vader.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35615 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755297AbdERViK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2017 17:38:10 -0400
Received: by mail-pf0-f177.google.com with SMTP id n23so29756654pfb.2
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2017 14:38:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170518210620.GA26871@vader.DHCP.thefacebook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

On Thu, May 18, 2017 at 02:06:20PM -0700, Omar Sandoval wrote:
> On Thu, May 18, 2017 at 02:13:07PM +0200, Johannes Thumshirn wrote:
> > Add a test group for tests of the SCSI generic driver and and
> > functions common to the SCSI generic driver and it's test cases.
> > 
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > ---
> >  common/sg      | 22 ++++++++++++++++++++++
> >  tests/sg/group | 40 ++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 62 insertions(+)
> >  create mode 100644 common/sg
> >  create mode 100644 tests/sg/group
> > 
> > diff --git a/common/sg b/common/sg
> > new file mode 100644
> > index 000000000000..30b5089c68f7
> > --- /dev/null
> > +++ b/common/sg
> > +# TODO: if this test group has extra requirements for what devices it can be
> > +# run on, it should define a group_device_requires() function. If tests in this
> > +# group can be run on the test device, it should return zero. Otherwise, it
> > +# should return non-zero and set the $SKIP_REASON variable. $TEST_DEV is the
> > +# full path of the block device (e.g., /dev/nvme0n1 or /dev/sda1), and
> > +# $TEST_DEV_SYSFS is the sysfs path of the disk (not the partition, e.g.,
> > +# /sys/block/nvme0n1 or /sys/block/sda).
> > +#
> > +# Usually, group_device_requires() just needs to check that the test device is
> > +# the right type of hardware or supports any necessary features using the
> > +# _test_dev_foo helpers. If group_device_requires() returns non-zero, all tests
> > +# in this group will be skipped on that device.
> > +# group_device_requires() {
> > +# 	_test_dev_is_foo && _test_dev_supports_bar
> > +# }
> 
> Leftover TODO, I'll remove it when applying. If we add an sg test that
> runs on an actual device, we can define group_device_requires().

On second though, since I had some comments for patch 3, just fix this
up when you resend.
