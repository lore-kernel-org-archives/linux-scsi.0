From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: devinfo: BLIST_TRY_VPD_PAGES for SanDisk Cruzer Blade
Date: Thu, 20 Jun 2019 16:32:38 -0400
Message-ID: <yq14l4kro9l.fsf@oracle.com>
References: <20190618013146.21961-1-marcos.souza.org@gmail.com>
        <20190618013146.21961-2-marcos.souza.org@gmail.com>
        <yq1r27quuod.fsf@oracle.com> <20190619094540.GA26980@continental>
        <20190619120346.GC26980@continental>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190619120346.GC26980@continental> (Marcos Paulo de Souza's
        message of "Wed, 19 Jun 2019 09:03:52 -0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.ibm.com>
List-Id: linux-scsi@vger.kernel.org


Marcos,

> My first idea was to add a vendor:product mapping at SCSI layer, but
> so far I haven't found one, so I added the model/vendor found by
> INQUIRY. Would it be better to check for prod:vendor (as values,
> instead of the description)?

Your patch is functionally fine. I'm just trying to establish how risky
it is for me to pick it up.

-- 
Martin K. Petersen	Oracle Linux Engineering
