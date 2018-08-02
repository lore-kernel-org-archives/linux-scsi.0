From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi:NCR5380: remove same check condition in
 NCR5380_select
Date: Thu, 2 Aug 2018 03:26:09 +0000
Message-ID: <c99a75a2905c1eef50f94ccc0871c36af431e21a.camel@wdc.com>
References: <1533179408-20631-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533179408-20631-1-git-send-email-zhongjiang@huawei.com>
Content-Language: en-US
Content-ID: <5F69C00D377E604BABA0BE272B4F5C93@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "zhongjiang@huawei.com" <zhongjiang@huawei.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "fthain@telegraphics.com.au" <fthain@telegraphics.com.au>, "schmitzmic@gmail.com" <schmitzmic@gmail.com>
Cc: "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "john.garry@huawei.com" <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2018-08-02 at 11:10 +-0800, zhong jiang wrote:
+AD4- The same check condition is redundant, so remove one of them.
+AD4-=20
+AD4- Signed-off-by: zhong jiang +ADw-zhongjiang+AEA-huawei.com+AD4-
+AD4- ---
+AD4-  drivers/scsi/NCR5380.c +AHw- 3 +---
+AD4-  1 file changed, 1 insertion(+-), 2 deletions(-)
+AD4-=20
+AD4- diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
+AD4- index 90ea0f5..2ecaf3f 100644
+AD4- --- a/drivers/scsi/NCR5380.c
+AD4- +-+-+- b/drivers/scsi/NCR5380.c
+AD4- +AEAAQA- -999,8 +-999,7 +AEAAQA- static struct scsi+AF8-cmnd +ACo-NCR=
5380+AF8-select(struct Scsi+AF8-Host +ACo-instance,
+AD4- =20
+AD4-  	/+ACo- Check for lost arbitration +ACo-/
+AD4-  	if ((NCR5380+AF8-read(INITIATOR+AF8-COMMAND+AF8-REG) +ACY- ICR+AF8-=
ARBITRATION+AF8-LOST) +AHwAfA-
+AD4- -	    (NCR5380+AF8-read(CURRENT+AF8-SCSI+AF8-DATA+AF8-REG) +ACY- host=
data-+AD4-id+AF8-higher+AF8-mask) +AHwAfA-
+AD4- -	    (NCR5380+AF8-read(INITIATOR+AF8-COMMAND+AF8-REG) +ACY- ICR+AF8-=
ARBITRATION+AF8-LOST)) +AHs-
+AD4- +-	    (NCR5380+AF8-read(CURRENT+AF8-SCSI+AF8-DATA+AF8-REG) +ACY- hos=
tdata-+AD4-id+AF8-higher+AF8-mask)) +AHs-
+AD4-  		NCR5380+AF8-write(MODE+AF8-REG, MR+AF8-BASE)+ADs-
+AD4-  		dsprintk(NDEBUG+AF8-ARBITRATION, instance, +ACI-lost arbitration, =
deasserting MR+AF8-ARBITRATE+AFw-n+ACI-)+ADs-
+AD4-  		spin+AF8-lock+AF8-irq(+ACY-hostdata-+AD4-lock)+ADs-

Has this patch been tested?

Thanks,

Bart.
