From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: st.c: fix kernel-doc mismatch
Date: Mon, 20 Nov 2017 22:18:37 -0500
Message-ID: <yq18tf0mi9e.fsf@oracle.com>
References: <fa663a7f-8248-9562-dda7-8c54e13b5824@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33980 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752151AbdKUDTO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2017 22:19:14 -0500
In-Reply-To: <fa663a7f-8248-9562-dda7-8c54e13b5824@infradead.org> (Randy
        Dunlap's message of "Mon, 20 Nov 2017 18:25:08 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>


Randy,

> Fix kernel-doc function name and comments in st.c::read_ns_show():
> change us to ns to match the function name.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
