From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH 2/3] hisi_sas: fix typo in setup_itct_v1_hw()
Date: Fri, 8 Jan 2016 04:30:49 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB4450944A@G9W0766.americas.hpqcorp.net>
References: <1450697709-120516-1-git-send-email-john.garry@huawei.com>
 <1450697709-120516-3-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450697709-120516-3-git-send-email-john.garry@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, "JBottomley@odin.com" <JBottomley@odin.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linuxarm@huawei.com" <linuxarm@huawei.com>, "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>, "xuwei5@hisilicon.com" <xuwei5@hisilicon.com>, "john.garry2@mail.dcu.ie" <john.garry2@mail.dcu.ie>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> We were doing a arithmetic comparison instead of logical shift by accident.
> Mis-programming the itct did not seem to make a difference to operation.
> 
> Fixes: abda97c2fe874 ("hisi_sas: Add dev_found")
> 
> Signed-off-by: John Garry <john.garry@huawei.com>

Reviewed-by: Shane Seymour <shane.seymour@hpe.com>
