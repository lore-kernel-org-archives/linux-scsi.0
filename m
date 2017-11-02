From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Checking the description for aac_comm_init()
Date: Thu, 2 Nov 2017 11:30:22 +0100
Message-ID: <d9d819d6-221b-d085-d5dc-a0b7425acf80@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: aacraid@microsemi.com, linux-scsi@vger.kernel.org, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

I have taken another look also at the implementation of the
function “aac_comm_init”.

http://elixir.free-electrons.com/linux/v4.14-rc7/source/drivers/scsi/aacraid/comminit.c#L333
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/drivers/scsi/aacraid/comminit.c?id=fa8785e862ef644f742558f1a8c91eca6f3f0004#n345

Can it be that the description for the possible return values is questionable
in the corresponding comment block at the moment?

Regards,
Markus
