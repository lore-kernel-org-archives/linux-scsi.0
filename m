From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] hpsa compatility fixes
Date: Tue, 29 Nov 2016 11:11:39 -0500
Message-ID: <yq1shqap8p0.fsf@sermon.lab.mkp.net>
References: <1479454369-100281-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28831 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751591AbcK2QL4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2016 11:11:56 -0500
In-Reply-To: <1479454369-100281-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Fri, 18 Nov 2016 08:32:46 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Martin Wilck <martin.wilck@suse.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Hi all, this is a patchset to get hpsa working on older
Hannes> controllers.  Most notably older controller do not support the
Hannes> extended REPORT PHYS command, so we need to fallback to the
Hannes> legacy version here.  I've also added a new sysfs HBA attribute
Hannes> 'ctlr_num', which displays the current controller number. With
Hannes> that attribute one can construct legacy '/dev/ccissX' symlinks
Hannes> to facilitate an update from older installations using the cciss
Hannes> driver.

Applied patches 1 and 3. Patch 2 is awaiting feedback from Microsemi.

-- 
Martin K. Petersen	Oracle Linux Engineering
