From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: be2iscsi: set errno on error path
Date: Mon, 05 Dec 2016 17:24:40 -0500
Message-ID: <yq1y3zuui8n.fsf@sermon.lab.mkp.net>
References: <1480828902-4406-1-git-send-email-bianpan201603@163.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480828902-4406-1-git-send-email-bianpan201603@163.com> (Pan
        Bian's message of "Sun, 4 Dec 2016 13:21:42 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Pan Bian <bianpan201603@163.com>
Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Pan" == Pan Bian <bianpan201603@163.com> writes:

Pan> Variable ret is reset in the loop, and its value will be 0 during
Pan> the second and after repeat of the loop. If pci_alloc_consistent()
Pan> returns a NULL pointer then, it will leaves with return value 0. 0
Pan> means no error, which is contrary to the fact. This patches fixes
Pan> the bug, explicitly assigning "-ENOMEM" to return variable ret on
Pan> the path that the call to pci_alloc_consistent() fails.

Applied patches 1 and 2 to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
