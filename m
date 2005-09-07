From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Wed, 07 Sep 2005 23:34:17 +0200
Message-ID: <431F5CD9.8030608@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0509071519080.4988-100000@iolanthe.rowland.org> <431F50EF.1060901@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53891 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932449AbVIGVez (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 17:34:55 -0400
In-Reply-To: <431F50EF.1060901@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> It is very bad to have to punish all devices on the
> "bus" just because one device failed.  Isn't there a better way
> to recover(*) a failed USB Storage device?

usb-storage implements scsi_mod bus reset as USB port reset. This 
affects only the failing device.

There is one scsi_mod bus per SCSI target in usb-storage. There is no 
mapping from scsi_mod bus to USB bus. The same is true for sbp2. 
Usb-storage and sbp2 actually don't care at all for the bus a device is 
attached to.

(Or at least that's how I understand the USB subsystem; I'm sure about 
the 1394 subsystem.)
-- 
Stefan Richter
-=====-=-=-= =--= --===
http://arcgraph.de/sr/
