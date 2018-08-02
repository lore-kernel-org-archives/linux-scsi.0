From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/2] scsi:qla1280: remove unnessary same condition check
Date: Thu, 2 Aug 2018 03:22:36 +0000
Message-ID: <4f6e32d59aec6a75332b36377ed719dda293fe45.camel@wdc.com>
References: <1533177901-19514-1-git-send-email-zhongjiang@huawei.com>
         <1533177901-19514-2-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533177901-19514-2-git-send-email-zhongjiang@huawei.com>
Content-Language: en-US
Content-ID: <40BE66B5F2E88F4EA54B1CFF3B566BCD@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>, "zhongjiang@huawei.com" <zhongjiang@huawei.com>, "aacraid@microsemi.com" <aacraid@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2018-08-02 at 10:45 +-0800, zhong jiang wrote:
+AD4- doulbe test in a expression is redundant. so just remove one of
+AD4- them.
+AD4-=20
+AD4- Signed-off-by: zhong jiang +ADw-zhongjiang+AEA-huawei.com+AD4-
+AD4- ---
+AD4-  drivers/scsi/qla1280.c +AHw- 1 -
+AD4-  1 file changed, 1 deletion(-)
+AD4-=20
+AD4- diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
+AD4- index 390775d..8e6f156 100644
+AD4- --- a/drivers/scsi/qla1280.c
+AD4- +-+-+- b/drivers/scsi/qla1280.c
+AD4- +AEAAQA- -1504,7 +-1504,6 +AEAAQA- static void qla1280+AF8-mailbox+AF=
8-timeout(struct timer+AF8-list +ACo-t)
+AD4-  	/+ACo- Issue SCSI reset, if we can't reset twice then bus is dead +=
ACo-/
+AD4-  	for (bus +AD0- 0+ADs- bus +ADw- ha-+AD4-ports+ADs- bus+-+-) +AHs-
+AD4-  		if (+ACE-ha-+AD4-bus+AF8-settings+AFs-bus+AF0-.disable+AF8-scsi+AF=
8-reset +ACYAJg-
+AD4- -		    qla1280+AF8-bus+AF8-reset(ha, bus) +ACYAJg-
+AD4-  		    qla1280+AF8-bus+AF8-reset(ha, bus))
+AD4-  			ha-+AD4-bus+AF8-settings+AFs-bus+AF0-.scsi+AF8-bus+AF8-dead +AD0-=
 1+ADs-
+AD4-  	+AH0-

Same question here: does qla1280+AF8-bus+AF8-reset() have any side effects?

Bart.
