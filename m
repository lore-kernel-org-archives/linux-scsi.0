From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2 v2] scsi: be2iscsi: set errno on error path
Date: Mon, 05 Dec 2016 17:29:30 -0500
Message-ID: <yq1twaiui0l.fsf@sermon.lab.mkp.net>
References: <1480922623-19261-1-git-send-email-bianpan2016@163.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480922623-19261-1-git-send-email-bianpan2016@163.com> (Pan
        Bian's message of "Mon, 5 Dec 2016 15:23:43 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Pan Bian <bianpan2016@163.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, Subbu Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Pan" == Pan Bian <bianpan2016@163.com> writes:

Pan> Variable ret is reset in the loop, and its value will be 0 during
Pan> the after repeat of the loop. Then, if pci_alloc_consistent()
Pan> returns NULL, the return value is 0. 0 means no error, which may
Pan> make it impossible for the callers of beiscsi_create_cqs() to
Pan> detect the memory allocation error. This patch fixes the bug,
Pan> assigning "-ENOMEM" to ret on the path that the call to
Pan> pci_alloc_consistent() fails.

What are the differences between v1 and v2 for these patches? I see no
changelog...

-- 
Martin K. Petersen	Oracle Linux Engineering
