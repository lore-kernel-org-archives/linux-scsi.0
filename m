From: Sander Smeenk <ssmeenk@freshdot.net>
Subject: Re: scsi_scan.c reports 'target allocation failed, error -6' w/
 mptsas
Date: Mon, 23 Jan 2012 14:03:44 +0100
Message-ID: <20120123130343.GA28136@dot.freshdot.net>
References: <20120118100635.GA19750@dot.freshdot.net>
 <A6888A6805518E4EA4AF7072A28264A60481F5304E@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dot.freshdot.net ([213.154.236.176]:40044 "EHLO
	dot.freshdot.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab2AWNqW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2012 08:46:22 -0500
Content-Disposition: inline
In-Reply-To: <A6888A6805518E4EA4AF7072A28264A60481F5304E@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Quoting Nandigama, Nagalakshmi (Nagalakshmi.Nandigama@lsi.com):

Sorry for the delay. We're all busy. :-)

> request you to provide the response of  "modinfo mptsas".
> Also please capture the logs with the scsi logging set to 0x180000DB.
> "echo 0x180000db > /proc/sys/dev/scsi/logging_level".
> And mptsas debug level set to 0x3f8
> "echo 3f8 > /sys/module/mptbase/parameters/mpt_debug_level"

This generated a lot of output, please find it in this paste:
http://8n1.org/raw/8314/8fd6

With this disk i did *NOT* do:

| echo 1 >/sys/block/sdN/deviCe/delete

before pulling the old drive from the system. This might well be related
as the new disk was detected properly after inserting and scanning this
time.

Thanks for your time!

With regards,
-Sander.
-- 
| Do people in Australia call the rest of the world "up over"?
| 4096R/20CC6CD2 - 6D40 1A20 B9AA 87D4 84C7  FBD6 F3A9 9442 20CC 6CD2
