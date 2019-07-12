From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aha1740: Use !x in place of NULL comparisons
Date: Thu, 11 Jul 2019 20:38:45 -0400
Message-ID: <yq17e8o84tm.fsf@oracle.com>
References: <20190711234833.27475-1-iamkeyur96@gmail.com>
        <1562889124.2915.5.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1562889124.2915.5.camel@linux.ibm.com> (James Bottomley's
        message of "Thu, 11 Jul 2019 16:52:04 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.ibm.com>
Cc: Keyur Patel <iamkeyur96@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


James,

> I also don't really think the replacement adds anything to readability,
> so it should probably be removed from the checkpatch warnings.

I agree.

-- 
Martin K. Petersen	Oracle Linux Engineering
