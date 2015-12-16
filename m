From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] qla2xxx: fix a timeout loop
Date: Wed, 16 Dec 2015 17:50:17 -0500
Message-ID: <yq1lh8ut3di.fsf@sermon.lab.mkp.net>
References: <20151216110746.GB21018@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50728 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbbLPWud (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 17:50:33 -0500
In-Reply-To: <20151216110746.GB21018@mwanda> (Dan Carpenter's message of "Wed,
	16 Dec 2015 14:07:46 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: qla2xxx-upstream@qlogic.com, Atul Deshmukh <atul.deshmukh@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> After the loop we test for "if (!retries) " as a failure, but
Dan> actually the post-op here will end with retries set to -1.  I have
Dan> fixed this by using a pre-op instead.

Applied to 4.4/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
