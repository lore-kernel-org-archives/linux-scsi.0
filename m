From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/6] scsi: lpfc: Cocci spatch "pool_zalloc-simple"
Date: Mon, 25 Sep 2017 19:06:39 -0400
Message-ID: <yq1lgl2e5ts.fsf@oracle.com>
References: <1505974468535-2047238743-0-diffsplit-thomas@m3y3r.de>
        <1505974468535-735692655-3-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505974468535-735692655-3-diffsplit-thomas@m3y3r.de> (Thomas
        Meyer's message of "Thu, 21 Sep 2017 08:15:26 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Thomas,

> Use *_pool_zalloc rather than *_pool_alloc followed by memset with 0.
> Found by coccinelle spatch "api/alloc/pool_zalloc-simple.cocci"

Applied to 4.15/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
