From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: megaraid_sas: problem with specific hardware only with kernel
 3.2.5 and above
Date: Wed, 19 Dec 2012 11:17:52 +0100
Message-ID: <50D19450.4010402@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:55107 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2LSKXi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Dec 2012 05:23:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michal.miszewski@gemius.com
Cc: linux-scsi@vger.kernel.org, Matthias Prager <linux@matthiasprager.de>

Hello everyone, hello Michal,

I can confirm and reproduce this issue on a different set of hardware:

Intel S1200BTLR Mainboard
LSI MegaRAID 9266-4i Raid-Controller

I haven't tried using a kernel older than 3.2.5 so far, but with kernels
3.2.24 and 3.5.0 I get the following dmesg output:

[    2.621164] megasas: 00.00.06.15-rc1 Mon. Mar. 19 17:00:00 PDT 2012
[    2.621179] megasas: 0x1000:0x005b:0x1000:0x9269: bus 1:slot 0:func 0
[    2.621599] megasas: Waiting for FW to come to ready state
[    2.621601] megasas: FW in FAULT state!!

As a result I can't access any drives connected to the controller.

Tested Controller firmwares: 23.7.0-0031, 23.7.0-0035 and 23.9.0-0015
Tested Mainboard BIOSes: R0037 (BMC 1.14, FRUSDR 1.14)

I contacted Intel and LSI support a while ago. Intel shot me down by
telling me this wasn't their problem. LSI at least tried to resolve the
issue but thus far failed to do so.

Unfortunately I don't have access to the system on a day-to-day basis,
but I will test eventual fixes as soon as I get the chance.

---
Matthias Prager
