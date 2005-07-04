From: collinm@laboiteaprog.com
Subject: scsi problem
Date: Mon,  4 Jul 2005 14:32:00 +0200
Message-ID: <1120480320.42c92c40c393b@webmail.laboiteaprog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv1.cineteck.net ([213.218.133.172]:4560 "EHLO
	pl5.cineteck.net") by vger.kernel.org with ESMTP id S261649AbVGDMcV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jul 2005 08:32:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: os2@videotron.ca
Cc: linux-scsi@vger.kernel.org

hi

i use suse 9.3 and kernel 2.6.11.4-21.7

with every 2.6.x kernel, i get the same problem...

with a 2.4 kernel that work fine

i have a cdrom connected to my scsi card

Jun 30 16:26:59 linuxdell kernel: Attached scsi generic sg0 at scsi0, channel 0,
id 0, lun 0,  type 0
Jun 30 16:26:59 linuxdell kernel: Attached scsi generic sg1 at scsi2, channel 0,
id 5, lun 0,  type 5
Jun 30 16:27:27 linuxdell kernel: sym0: SCSI parity error detected: SCR1=132
DBC=50000000 SBCL=0
Jun 30 16:28:07 linuxdell kernel: sym0: SCSI BUS reset detected.
Jun 30 16:28:07 linuxdell kernel: sym0: SCSI BUS has been reset.
Jun 30 16:28:17 linuxdell kernel: sym0: SCSI BUS has been reset.
Jun 30 16:28:27 linuxdell kernel: scsi: Device offlined - not ready after error
recovery: host 2 channel 0 id 5 lun 0
Jun 30 16:28:27 linuxdell kernel: scsi2 (5:0): rejecting I/O to offline device

the driver i use is: sym53c8xx

on the web everybody seem to have the same problem with this driver...

somebody know when the problem will be resolved?

with another scsi card who don't use sym driver..., all work fine..

thanks

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.

