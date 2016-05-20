From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aacraid: do not activate events on non-SRC adapters
Date: Thu, 19 May 2016 22:18:05 -0400
Message-ID: <yq1shxda2w2.fsf@sermon.lab.mkp.net>
References: <1463559411-100841-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45753 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbcETCS0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2016 22:18:26 -0400
In-Reply-To: <1463559411-100841-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Wed, 18 May 2016 10:16:51 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Only SRC-based adapters support the AifReqEvent function, so
Hannes> there is no point in trying to activate it on older, non-SRC
Hannes> based adapters.  Doing so lead to crashes on older adapters.

Applied to 4.7/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
