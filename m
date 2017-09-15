From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] aacraid: Fix 2T+ drives on SmartIOC-2000
Date: Fri, 15 Sep 2017 15:50:19 -0400
Message-ID: <yq1r2v7oi6c.fsf@oracle.com>
References: <20170915170428.15237-1-david.carroll@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170915170428.15237-1-david.carroll@microsemi.com> (Dave
        Carroll's message of "Fri, 15 Sep 2017 11:04:28 -0600")
Sender: stable-owner@vger.kernel.org
To: Dave Carroll <david.carroll@microsemi.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, aacraid@microsemi.com, Scott Benesh <scott.benesh@microsemi.com>, Brian King <brking@linux.vnet.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Dave,

> The logic for supporting large drives was previously tied to 4Kn
> support for SmartIOC-2000. As SmartIOC-2000 does not support volumes
> using 4Kn drives, use the intended option flag AAC_OPT_NEW_COMM_64 to
> determine support for volumes greater than 2T.

Applied to 4.14/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
