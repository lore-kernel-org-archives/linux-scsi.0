From: Kevin Groeneveld <KGroeneveld@lenbrook.com>
Subject: RE: [PATCH v2 1/2] scsi: fix race between simultaneous decrements
 of ->host_failed
Date: Wed, 1 Jun 2016 14:36:05 +0000
Message-ID: <BF6B9AADDDF11740967545E971C7C0DE6B861A22@MAIL1.pickering.lenbrook.com>
References: <1464683898-9877-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1464683898-9877-1-git-send-email-fangwei1@huawei.com>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>, "tj@kernel.org" <tj@kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "corbet@lwn.net" <corbet@lwn.net>
Cc: "hch@infradead.org" <hch@infradead.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> Subject: [PATCH v2 1/2] scsi: fix race between simultaneous decrements of ->host_failed

I wonder if this could be related to http://www.spinics.net/lists/linux-scsi/msg86808.html?

I never did get to the bottom of that.  If I have time I hope to retest my scsi hang issue with this patch.


Kevin
