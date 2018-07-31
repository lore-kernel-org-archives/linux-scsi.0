From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: 3ware: fix return 0 on the error path of probe
Date: Mon, 30 Jul 2018 22:08:26 -0400
Message-ID: <yq1o9eow411.fsf@oracle.com>
References: <20180727135157.13051-1-vasilyev@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180727135157.13051-1-vasilyev@ispras.ru> (Anton Vasilyev's
        message of "Fri, 27 Jul 2018 16:51:57 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Anton Vasilyev <vasilyev@ispras.ru>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Adam Radford <aradford@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org


Anton,

> tw_probe() returns 0 in case of fail of tw_initialize_device_extension(),
> pci_resource_start() or tw_reset_sequence() and releases resources.
> twl_probe() returns 0 in case of fail of twl_initialize_device_extension(),
> pci_iomap() and twl_reset_sequence().
> twa_probe() returns 0 in case of fail of tw_initialize_device_extension(),
> ioremap() and twa_reset_sequence().

Applied to 4.19/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
