From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: udev hangs USB-storage (HP r707 camera)
Date: Sun, 20 Jan 2008 01:53:51 +0100
Message-ID: <47929B9F.8080607@s5r6.in-berlin.de>
References: <20080119174556.GE11553@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48842 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbYATAx5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Jan 2008 19:53:57 -0500
In-Reply-To: <20080119174556.GE11553@colo.lackof.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Grant Grundler wrote:
>     https://bugs.launchpad.net/ubuntu/+source/hal/+bug/180472
...
> I have a usbmon trace for 2.6.23.13 (appended) along with dmesg output.
> What I need is someone to interpret this trace, tell me what happened,
> then I can work on tracking down "vol_id"'s role in this mess.

You can also enable SCSI command logging.  Perhaps userspace sends a
specific command which offends the device (because The Other OS wouldn't
send that command in this order of sequence).
# echo 9216 > /sys/module/scsi_mod/parameters/scsi_logging_level
That's what I wrote down on a piece of paper a long time ago; don't ask
me what it means in detail.  :-)
-- 
Stefan Richter
-=====-==--- ---= =-=--
http://arcgraph.de/sr/
