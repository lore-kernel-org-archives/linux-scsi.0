From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Thu, 06 Feb 2014 08:50:03 -0500
Message-ID: <yq161osuz90.fsf@sermon.lab.mkp.net>
References: <1391157974-17512-1-git-send-email-hare@suse.de>
	<52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de>
	<60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi>
	<52EE2F2D.1010300@suse.de> <52EFACA4.6060001@tributary.com>
	<52EFB06C.8010101@suse.de> <52EFB0E7.3000504@tributary.com>
	<CAPXgP13dn+VGpu0OLHatUvP4TRDp2YEgCXYB837ReADZTWg_NA@mail.gmail.com>
	<52F010F9.5090305@tributary.com> <52F389A9.808@suse.de>
	<yq1eh3gv0l9.fsf@sermon.lab.mkp.net> <52F38D78.2070002@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36303 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbaBFNuZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 08:50:25 -0500
In-Reply-To: <52F38D78.2070002@suse.de> (Hannes Reinecke's message of "Thu, 06
	Feb 2014 14:26:16 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, =?utf-8?Q?Kai_M?= =?utf-8?Q?=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

>> My patch provides both the original VPD 0x83 and 0x80 bits as well as
>> a handle identical to /sbin/scsi_id.
>> 
Hannes> Bah, don't do that.  That should better be handled by udev
Hannes> rules.  I've got a set of patches moving from scsi_id to sg_inq,
Hannes> which can be easily adapted to using sysfs directly.

I just want to get out of the "userland sending random SCSI commands"
business. That is a world of pain right now.

I wanted to provide a handle that was guaranteed to be compatible with
existing tooling. If you have worked around that in udev rules I guess
that's OK with me.

-- 
Martin K. Petersen	Oracle Linux Engineering
