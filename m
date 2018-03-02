From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: Keep disk read-only when re-reading partition
Date: Thu, 01 Mar 2018 20:53:46 -0500
Message-ID: <yq1vaefxmxh.fsf@oracle.com>
References: <01000161e1e448a5-d54e05d2-58f2-4480-b05b-67185d4ffae7-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <01000161e1e448a5-d54e05d2-58f2-4480-b05b-67185d4ffae7-000000@email.amazonses.com>
        (Jeremy Cline's message of "Thu, 1 Mar 2018 14:08:10 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Jeremy Cline <jeremy@jcline.org>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Jeremy,

Thanks for looking into this!

> This commit reads the disk's old state and combines it with the device
> disk-reported state rather than unconditionally marking it as RW.

Applied to 4.16/scsi-fixes with a few minor tweaks. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
