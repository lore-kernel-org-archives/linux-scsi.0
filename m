From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Spinup of SCSI Disks: allow_restart won't work on 2.6.18
Date: Tue, 21 Nov 2006 21:49:34 +0100
Message-ID: <4563665E.2060301@s5r6.in-berlin.de>
References: <455DF39A.6090209@fbihome.de> <455E2D44.5030903@gmx.de> <455E4703.3080005@s5r6.in-berlin.de> <456188FD.3020108@fbihome.de> <45619611.5020502@s5r6.in-berlin.de> <45622CF5.507@fbihome.de> <45624009.3040208@s5r6.in-berlin.de> <456251E2.4010700@fbihome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:25014 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1031241AbWKUUtj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 15:49:39 -0500
In-Reply-To: <456251E2.4010700@fbihome.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joern Quillmann <quillman@fbihome.de>
Cc: linux-scsi@vger.kernel.org

Joern Quillmann wrote:
> Stefan Richter wrote:
>>> ieee1394: sbp2: Error logging into SBP-2 device - timed out
>>> sbp2: probe of 0001d20000093c4d-0 failed with error -16
>>
>> This should not be a problem per se, although it won't be possible to
>> actually use the disk after a login failure of course.
> 
> The remaining disks were not found too.

Because of the subsequent oops in ieee1394's nodemgr context, which runs
all the device probes.

...
>> if you can reproduce this bug, I could send you a
>> patch with a bunch of printk's to narrow the offending sysfs attribute
>> down.
> 
> Sure no problem. I'll test it asap.
> Would be great to get a solution for this too. Kinda unfunny to always
> have the external disks running before the system boots.

I'll get back to you once I have something to work on the oops or/and
the login failure.
-- 
Stefan Richter
-=====-=-==- =-== =-=-=
http://arcgraph.de/sr/
