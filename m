From: Bernd Schubert <bs@q-leap.de>
Subject: need help to suspend a device
Date: Wed, 5 Dec 2007 14:43:31 +0100
Message-ID: <200712051443.32176.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:35692 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbXLENnd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Dec 2007 08:43:33 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

Hi,

I need some help with device suspending or something similar to this.

Problem description: We have many many Infortrend sata-to-scsi-raid systems 
here, connected to several server systems with LSI2230 HBAs.
Now the problem is, that these Infortrend boxes sometimes suffer from some 
kind of hick-up, sometimes due to the reboot of second server connected to 
the very same Infortrend box and sometimes just for no obvious reason. 

As far I can presently see it, the best would be to suspend any i/o, commands, 
etc to the troublesome box for about 30s to 60s and just wait and then to 
repeat the last command.
However, presently the scsi-layer/driver will immediately begin a domain 
validation and then do a scsi-reset. Unfortunately this will cause even more 
trouble. Sometimes this works, in more cases it will end in an i/o error and 
in most cases these domain validations and scsi-resets will go into an 
endless loop and eventually the Infortrend raids will be so confused that 
their scsi-controller will crash.

I'm already looking for some hours through the scsi and mpt functions, but so 
far didn't find a good way to put commands to a scsi-device to sleep for some 
time.

Any hints and suggestions are highly appreciated.


Thanks in advance,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
