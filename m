From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: rescan VPD attributes
Date: Wed, 25 Nov 2015 22:34:33 -0500
Message-ID: <yq17fl5juwm.fsf@sermon.lab.mkp.net>
References: <1447071868-8509-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35252 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbbKZDep (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2015 22:34:45 -0500
In-Reply-To: <1447071868-8509-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Mon, 9 Nov 2015 13:24:28 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.Petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> The VPD page information might change, so we need to be able to
Hannes> update it. This patch implements a VPD page rescan whenever the
Hannes> 'rescan' sysfs attribute is triggered.

I was looking into merging the ALUA series but this prerequisite patch
is lacking reviews...

-- 
Martin K. Petersen	Oracle Linux Engineering
