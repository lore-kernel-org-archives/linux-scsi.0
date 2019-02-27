From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/2] scsi: replace GFP_ATOMIC with GFP_KERNEL for allocations in scsi_scan.c
Date: Wed, 27 Feb 2019 09:40:39 -0500
Message-ID: <yq1h8cp9tw8.fsf@oracle.com>
References: <20190220184847.24640-1-bblock@linux.ibm.com>
        <c5bd5a82d1250471822cbf5891ea1866166cd9e6.1550740533.git.bblock@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c5bd5a82d1250471822cbf5891ea1866166cd9e6.1550740533.git.bblock@linux.ibm.com>
        (Benjamin Block's message of "Thu, 21 Feb 2019 10:18:00 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Block <bblock@linux.ibm.com>
Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Steffen Maier <maier@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org


Benjamin,

> We had a test-report where, under memory pressure, adding LUNs to the
> systems would fail (the tests add LUNs strictly in sequence):

Applied to 5.1/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
