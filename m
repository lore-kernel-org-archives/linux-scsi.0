From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 03/22] scsi: Fix dependencies for !HAS_IOMEM and !HAS_DMA archs
Date: Tue, 26 Jan 2016 21:16:28 -0500
Message-ID: <yq137tjix6r.fsf@sermon.lab.mkp.net>
References: <1453760661-1444-1-git-send-email-richard@nod.at>
	<1453760661-1444-4-git-send-email-richard@nod.at>
	<56A74743.6000308@huawei.com> <56A74AF6.90307@nod.at>
	<56A75082.6050104@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18351 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbcA0CQu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2016 21:16:50 -0500
In-Reply-To: <56A75082.6050104@huawei.com> (John Garry's message of "Tue, 26
	Jan 2016 10:54:58 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

>>>>> "John" == John Garry <john.garry@huawei.com> writes:

John> We can just add HAS_IOMEM dependency on the scsi fixes branch, ok?

Yes, please submit a patch against 4.5/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
