From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Subject: QLGC,ISP SCSI driver not finding attached devices
Date: Mon, 23 Jul 2007 23:41:34 +0100 (BST)
Message-ID: <Pine.LNX.4.61.0707232315510.16213@mtfhpc.demon.co.uk>
References: <Pine.LNX.4.61.0707201404250.7470@mtfhpc.demon.co.uk>
 <1184941136.3455.8.camel@localhost.localdomain>
 <Pine.LNX.4.61.0707201602080.7721@mtfhpc.demon.co.uk>
 <1184950646.3455.45.camel@localhost.localdomain>
 <Pine.LNX.4.61.0707201822250.8013@mtfhpc.demon.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from anchor-post-36.mail.demon.net ([194.217.242.86]:4235 "EHLO
	anchor-post-36.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbXGWWlk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jul 2007 18:41:40 -0400
In-Reply-To: <Pine.LNX.4.61.0707201822250.8013@mtfhpc.demon.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: davem@davemloft.net, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org

Hi James,

Can you point me in the direction of any documentation to aid me in 
identifing what debugging I need to work out what is going on?

For targets without any connected disk, I get scan responses of:
     scsi scan: INQUIRY failed with code 0x40000
after app 417ms.

For targets with a disk connected, I get scan responses of:
     scsi scan: INQUIRY failed with code 0x8000002
after app 170ms.

Can you tell me how to decode the error codes?
(The times are from the sun4c 1us counter14)

I did get the driver to work on one occasion but I have not been able to 
repeat the achivement.

I can also get the ESP driver to fail to find disks with the same error 
codes if I build it as a module driver however if I build the ESP driver 
into the kernel, it does not fail (ESP BUS_TIMEOUT=275).

Regards
 	Mark Fortescue.


