From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: replace GFP_ATOMIC with GFP_KERNEL for sdev
 allocation
Date: Wed, 20 Feb 2019 11:11:31 -0800
Message-ID: <1550689891.93548.31.camel@acm.org>
References: <20190220184847.24640-1-bblock@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190220184847.24640-1-bblock@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Block <bblock@linux.ibm.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Steffen Maier <maier@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2019-02-20 at 19:48 +-0100, Benjamin Block wrote:
+AD4 We had a test-report where, under memory pressure, adding LUNs to the
+AD4 systems would fail (the tests add LUNs strictly in sequence):

Hi Benjamin,

There are two more instances of GFP+AF8-ATOMIC in scsi+AF8-scan.c. Have you verified
whether or not it is safe to change these into GFP+AF8-KERNEL too?

Thanks,

Bart.
