From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5] sd: Check for unaligned partial completion
Date: Mon, 20 Feb 2017 23:01:50 -0500
Message-ID: <yq1vas42nv5.fsf@oracle.com>
References: <20170217000130.22471-1-damien.lemoal@wdc.com>
        <yq11sus5l0j.fsf@oracle.com>
        <6789928a-08c5-0b0e-ac45-de2225a2e0e0@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21665 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdBUECH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2017 23:02:07 -0500
In-Reply-To: <6789928a-08c5-0b0e-ac45-de2225a2e0e0@wdc.com> (Damien Le Moal's
        message of "Tue, 21 Feb 2017 12:45:07 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>

>>>>> "Damien" == Damien Le Moal <damien.lemoal@wdc.com> writes:

Damien,

Damien> Initially, I didn't want to change more than I did so that the
Damien> patch quickly make it to 4.10 and we get ZBC working with LSI
Damien> HBAs. Since this did not happen and we have more time ahead, I
Damien> can respin everything into sd_completed_bytes to clean things
Damien> up.

Damien> I will resend a patch.

Great, thanks! Would be nice to get this cleaned up.

-- 
Martin K. Petersen	Oracle Linux Engineering
