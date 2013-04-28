From: =?ISO-8859-1?Q?Johnny_Str=F6m?= <johnny.strom@linuxsolutions.fi>
Subject: lpfc and FLOGI failure.
Date: Sun, 28 Apr 2013 18:49:15 +0300
Message-ID: <517D44FB.5050206@linuxsolutions.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from av8.netikka.fi ([213.250.83.8]:40697 "EHLO av8.netikka.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738Ab3D1P4h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Apr 2013 11:56:37 -0400
Received: from mail.linuxsolutions.fi (mail.linuxsolutions.fi [127.0.0.1])
	by av8.netikka.fi (Postfix) with ESMTP id 77BAD4440340
	for <linux-scsi@vger.kernel.org>; Sun, 28 Apr 2013 18:49:15 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello

We have an Emulex LPe1150 that is causing FLOGI failure when the driver 
is loaded.

We have updated the firmware on the card. It is working ok with an old 
HP MSA.

But with an new MD36xxf so dose it not work.

when the lpfc driver is loded so dose it take about 7 seconds to load 
and efter that so
do we only see these LUN's: We do not see the other disk LUN's

[16:0:0:0]   disk    DELL     MD36xxf          0784  -
[16:0:0:31]  disk    DELL     Universal Xport  0784  -


dmesg shows this after the driver is loaded.

[15313.555729] scsi12 : Emulex LPe1150 1Gb PCIe Fibre Channel Adapter on 
PCI bus 0e device 00 irq 30
[15317.795558] lpfc 0000:0e:00.0: 1:1303 Link Up Event x1 received Data: 
x1 x1 x10 x2 x0 x0 0
[15317.795680] lpfc 0000:0e:00.0: 1:1309 Link Up Event npiv not 
supported in loop topology
[15317.796111] lpfc 0000:0e:00.0: 1:(0):2858 FLOGI failure Status:x3/x18 
TMO:x0
[15317.796423] lpfc 0000:0e:00.0: 1:(0):2858 FLOGI failure Status:x3/x18 
TMO:x0
[15317.796726] lpfc 0000:0e:00.0: 1:(0):2858 FLOGI failure Status:x3/x18 
TMO:x0
[15317.796825] lpfc 0000:0e:00.0: 1:(0):0100 FLOGI failure Status:x3/x18 
TMO:x0

Could it be an bug in the lpfc driver when it is used with MD36xxf?
Any suggestions what to do or try?

I have tried kernel version 3.8.8 and it has the same issue.

Best Johnny
