From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: remove incorrect lockdep assertion
Date: Mon, 25 Apr 2016 22:07:30 -0400
Message-ID: <yq160v5i0m5.fsf@sermon.lab.mkp.net>
References: <20160417132727.000026f3@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16391 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbcDZCHo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2016 22:07:44 -0400
In-Reply-To: <20160417132727.000026f3@localhost> (Sebastian Herbszt's message
	of "Sun, 17 Apr 2016 13:27:27 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>

>>>>> "Sebastian" == Sebastian Herbszt <herbszt@gmx.de> writes:

Sebastian> Remove incorrect lockdep assertion from
Sebastian> lpfc_sli_hbqbuf_find() which acquires the hbalock itself. Fix
Sebastian> the comment which resulted in this mistake.

Applied to 4.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
