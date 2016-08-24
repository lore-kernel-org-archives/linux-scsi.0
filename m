From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid_sas: Use memdup_user() rather than duplicating its implementation
Date: Tue, 23 Aug 2016 22:47:47 -0400
Message-ID: <yq1zio2dgrw.fsf@sermon.lab.mkp.net>
References: <566ABCD9.1060404@users.sourceforge.net>
        <606e0b0c-370f-cff5-607b-0c8ae480e9c1@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <606e0b0c-370f-cff5-607b-0c8ae480e9c1@users.sourceforge.net> (SF
        Markus Elfring's message of "Sun, 21 Aug 2016 10:48:48 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, megaraidlinux.pdl@avagotech.com, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, Kashyap Desai <kashyap.desai@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

>>>>> "SF" == SF Markus Elfring <elfring@users.sourceforge.net> writes:

SF> Reuse existing functionality from memdup_user() instead of keeping
SF> duplicate source code.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
