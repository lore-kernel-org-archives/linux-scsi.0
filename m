From: Kevin Groeneveld <KGroeneveld@lenbrook.com>
Subject: RE: [PATCH v2 1/2] scsi: fix race between simultaneous decrements
 of ->host_failed
Date: Mon, 6 Jun 2016 12:48:09 +0000
Message-ID: <BF6B9AADDDF11740967545E971C7C0DE6B863065@MAIL1.pickering.lenbrook.com>
References: <1464683898-9877-1-git-send-email-fangwei1@huawei.com>
 <BF6B9AADDDF11740967545E971C7C0DE6B861A22@MAIL1.pickering.lenbrook.com>
 <574F9BE4.4020405@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <574F9BE4.4020405@huawei.com>
Content-Language: en-US
Sender: linux-doc-owner@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>, "tj@kernel.org" <tj@kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "corbet@lwn.net" <corbet@lwn.net>
Cc: "hch@infradead.org" <hch@infradead.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

-----Original Message-----
From: Wei Fang [mailto:fangwei1@huawei.com] 
Sent: June-01-16 10:37 PM

>The concurrently decrements of host_failed only lead to abnormal of host_failed, host_busy will be zero after error handler, and >the result may be host_failed > host_busy forever. But in your case, host_busy > host_failed, so I think it's not the same case. I'm >afraid that this patch can't fix your scsi hang issue.

I tested the patch and you (and others also suggested similar) are correct that it does not fix the error handling issue I am having with port multipliers and CD-ROM+HDD.


Kevin
