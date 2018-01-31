From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mptfusion: Add bounds check in mptctl_hp_targetinfo()
Date: Tue, 30 Jan 2018 21:32:38 -0500
Message-ID: <yq1fu6mg3ll.fsf@oracle.com>
References: <20180125142727.GA23945@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33802 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbeAaCoK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jan 2018 21:44:10 -0500
In-Reply-To: <20180125142727.GA23945@mwanda> (Dan Carpenter's message of "Thu,
        25 Jan 2018 17:27:27 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


Dan,

> My static checker complains about an out of bounds read:
>
>     drivers/message/fusion/mptctl.c:2786 mptctl_hp_targetinfo()
>     error: buffer overflow 'hd->sel_timeout' 255 <= u32max.
>
> It's true that we probably should have a bounds check here.

Applied to 4.16/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
