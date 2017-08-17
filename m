From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: osst: silence underflow warning in osst_verify_frame()
Date: Wed, 16 Aug 2017 20:32:26 -0400
Message-ID: <yq1pobvowyt.fsf@oracle.com>
References: <20170804081733.ujuulvyh4nwgdl6n@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47953 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751461AbdHQAcm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 20:32:42 -0400
In-Reply-To: <20170804081733.ujuulvyh4nwgdl6n@mwanda> (Dan Carpenter's message
        of "Fri, 4 Aug 2017 11:17:33 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Willem Riede <osst@riede.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


Dan,

> If i is negative then it's less than OS_FM_TAB_MAX so we read before
> the start of the STp->header_cache->dat_fm_tab.fm_tab_ent[] array.

Applied to 4.14/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
