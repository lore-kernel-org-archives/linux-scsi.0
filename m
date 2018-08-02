From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 2/2] scsi:qlogicfas408: remove the same check in
 qlogicfas408_detect
Date: Thu, 2 Aug 2018 03:52:14 +0000
Message-ID: <2ff30988089f3cbc0d2127dbfaa29955e0449997.camel@wdc.com>
References: <1533177901-19514-1-git-send-email-zhongjiang@huawei.com>
         <1533177901-19514-3-git-send-email-zhongjiang@huawei.com>
         <dc1f8e81007466172d383cc63a4be246c568a2d4.camel@wdc.com>
         <5B627AB2.8000101@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5B627AB2.8000101@huawei.com>
Content-Language: en-US
Content-ID: <73802270CCDF2E48B707FDE28290CB10@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "zhongjiang@huawei.com" <zhongjiang@huawei.com>
Cc: "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>, "aacraid@microsemi.com" <aacraid@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "john.garry@huawei.com" <john.garry@huawei.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2018-08-02 at 11:29 +-0800, zhong jiang wrote:
+AD4- On 2018/8/2 11:21, Bart Van Assche wrote:
+AD4- +AD4- On Thu, 2018-08-02 at 10:45 +-0800, zhong jiang wrote:
+AD4- +AD4- +AD4- we should not use same check in a expression. just remove=
 one
+AD4- +AD4- +AD4- of them.
+AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- Signed-off-by: zhong jiang +ADw-zhongjiang+AEA-huawei.com=
+AD4-
+AD4- +AD4- +AD4- ---
+AD4- +AD4- +AD4-  drivers/scsi/qlogicfas408.c +AHw- 3 +---
+AD4- +AD4- +AD4-  1 file changed, 1 insertion(+-), 2 deletions(-)
+AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/q=
logicfas408.c
+AD4- +AD4- +AD4- index 8b471a9..1409ac1 100644
+AD4- +AD4- +AD4- --- a/drivers/scsi/qlogicfas408.c
+AD4- +AD4- +AD4- +-+-+- b/drivers/scsi/qlogicfas408.c
+AD4- +AD4- +AD4- +AEAAQA- -567,8 +-567,7 +AEAAQA- void qlogicfas408+AF8-se=
tup(int qbase, int id, int int+AF8-type)
+AD4- +AD4- +AD4-  int qlogicfas408+AF8-detect(int qbase, int int+AF8-type)
+AD4- +AD4- +AD4-  +AHs-
+AD4- +AD4- +AD4-          REG1+ADs-
+AD4- +AD4- +AD4- -	return (((inb(qbase +- 0xe) +AF4- inb(qbase +- 0xe)) +A=
D0APQ- 7) +ACYAJg-
+AD4- +AD4- +AD4- -	       ((inb(qbase +- 0xe) +AF4- inb(qbase +- 0xe)) +AD=
0APQ- 7))+ADs-	=09
+AD4- +AD4- +AD4- +-	return (inb(qbase +- 0xe) +AF4- inb(qbase +- 0xe)) +AD=
0APQ- 7+ADs-
+AD4- +AD4- +AD4-  +AH0-
+AD4- +AD4-=20
+AD4- +AD4- Does inb() have any side effects?
+AD4-=20
+AD4-  just redundant. is it necessary for this . Maybe I miss something.

If doubletest.cocci came up with this patch, I think that script is
wrong and needs a thorough review.

Bart.
