From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi: mvsas: replace kfree with scsi_host_put
Date: Thu, 10 Aug 2017 20:05:48 -0400
Message-ID: <yq1lgmr2ckj.fsf@oracle.com>
References: <1502193771-20271-1-git-send-email-bianpan2016@163.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502193771-20271-1-git-send-email-bianpan2016@163.com> (Pan
        Bian's message of "Tue, 8 Aug 2017 20:02:51 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Pan Bian <bianpan2016@163.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Jinpu Wang <jinpu.wang@profitbricks.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Pan,

> The return value of scsi_host_alloc() should be released by
> scsi_host_put(). However, in function mvs_pci_init(), kfree()
> is used. This patch replaces kfree() with scsi_host_put() to avoid
> possible memory leaks.

Applied to 4.14/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
