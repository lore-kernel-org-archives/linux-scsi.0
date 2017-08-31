From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] scsi: aacraid: report -ENOMEM to upper layer from aac_convert_sgraw2()
Date: Wed, 30 Aug 2017 22:03:10 -0400
Message-ID: <yq1r2vsxzmp.fsf@oracle.com>
References: <d039d8dcc35ced04bf27f20a653532429486d190.1504007944.git.npajkovsky@suse.cz>
        <d039d8dcc35ced04bf27f20a653532429486d190.1504007944.git.npajkovsky@suse.cz>
        <29ed79bb97060429247eeafc9d6d8f6793a7f6b5.1504007944.git.npajkovsky@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42176 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750973AbdHaCDX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2017 22:03:23 -0400
In-Reply-To: <29ed79bb97060429247eeafc9d6d8f6793a7f6b5.1504007944.git.npajkovsky@suse.cz>
        (Nikola Pajkovsky's message of "Tue, 29 Aug 2017 13:59:04 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nikola Pajkovsky <npajkovsky@suse.cz>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Nikola,

> aac_convert_sgraw2() kmalloc memory and return -1 on error, which
> should be -ENOMEM. However, nobody is checking return value, so with
> this change, -ENOMEM is propagated to upper layer.

Applied to 4.14/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
