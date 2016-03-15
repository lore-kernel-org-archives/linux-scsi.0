From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: vpd pages are mandatory for SPC-2
Date: Tue, 15 Mar 2016 17:36:23 -0400
Message-ID: <yq1pouve84o.fsf@sermon.lab.mkp.net>
References: <1457703965-71028-1-git-send-email-hare@suse.de>
	<yq137rshbrr.fsf@sermon.lab.mkp.net> <56E7B9AA.3020302@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47189 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbcCOVge (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2016 17:36:34 -0400
In-Reply-To: <56E7B9AA.3020302@suse.de> (Hannes Reinecke's message of "Tue, 15
	Mar 2016 08:28:42 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

>> I wonder how many non-compliant devices we would have to blacklist as
>> a result of this change...

Hannes> But it feels even sillier having to whitelist every
Hannes> standards-conformant device here; I certainly was when I figured
Hannes> that EMC Clariion won't work properly without this patch.

Hannes> And the idea was to mark off _misbehaving_ drives, not the other
Hannes> way round.

I understand. But my concern is that the number of broken USB doodad
model strings far outnumber enterprise storage vendor ditto. And there
is no point in reversing the polarity if it increases the maintenance
burden.

So I would be more comfortable with just widening the VPD whitelist and
assume that everything with an EMC, Dell, NetApp, whatever vendor ID is
compliant.

-- 
Martin K. Petersen	Oracle Linux Engineering
