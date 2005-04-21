From: "Eustache Safari" <eustache.safari@vodacom.cd>
Subject: HP smart array 6400 problem
Date: Thu, 21 Apr 2005 16:57:57 +0100
Message-ID: <90142A451F6F7D4EA75379F5194DF52901CC9ECA@cdkin02100.vodacom.cd>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [193.110.104.238] ([193.110.104.238]:62393 "EHLO
	cdkin02200.vodacom.cd") by vger.kernel.org with ESMTP
	id S261458AbVDUP5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2005 11:57:45 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello list,

I'm trying to install the HP Smart Array 6402 U320 dual channel to a HP
Proliant ML 370 G2 server, and OS RedHat Linux 7.2.
After I've installed the hardware and configured 4 x 18.2 GB SCSI Hard
Drive in RAID 5, I've followed all the process as described by HP on
their web site:
1) I've downloaded the updated disk driver for the smart array and the
'Anaconda update'.
2) I've also updated the firmware to the latest available version
3) The installation went fine. Then after, I've loaded the driver fixes,
to update the boot loaded.

My problem begins here.
On the first reboot (after I've loaded the fixes), everything is fine.
But, on subsequent reboot, the system doesn't recall to have the smart
array driver installed. And for sure, I can't move forward. It just
provides the prompt (Ctrl-D...)

Can some one assist me ! Will really appreciate.

Thanks

Eustache
