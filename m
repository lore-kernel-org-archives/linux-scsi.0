From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Thu, 06 Feb 2014 08:21:06 -0500
Message-ID: <yq1eh3gv0l9.fsf@sermon.lab.mkp.net>
References: <1391157974-17512-1-git-send-email-hare@suse.de>
	<52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de>
	<60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi>
	<52EE2F2D.1010300@suse.de> <52EFACA4.6060001@tributary.com>
	<52EFB06C.8010101@suse.de> <52EFB0E7.3000504@tributary.com>
	<CAPXgP13dn+VGpu0OLHatUvP4TRDp2YEgCXYB837ReADZTWg_NA@mail.gmail.com>
	<52F010F9.5090305@tributary.com> <52F389A9.808@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34741 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238AbaBFNVX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 08:21:23 -0500
In-Reply-To: <52F389A9.808@suse.de> (Hannes Reinecke's message of "Thu, 06 Feb
	2014 14:10:01 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, =?utf-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Moving EVPD page 0x83 (and maybe 0x80, too) into sysfs will save
Hannes> quite a lot of headache we have currently; udev won't have to
Hannes> call 'sg_inq', information will be present even though the
Hannes> device itself might be temporarily unavailable yadda yadda.

Hannes> So I've decided to bite the bullet and sent out a patch, check
Hannes> for 'Add EVPD page 0x83 entries to sysfs'.

I'm already doing something similar since I need it for xcopy.

My patch provides both the original VPD 0x83 and 0x80 bits as well as a
handle identical to /sbin/scsi_id.

I'll take a look at your patch later today...

-- 
Martin K. Petersen	Oracle Linux Engineering
