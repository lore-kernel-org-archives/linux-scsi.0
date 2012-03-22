From: Lin Ming <mlin@ss.pku.edu.cn>
Subject: [PATCH 0/2]: Use correct DMA device in SCSI/libata
Date: Fri, 23 Mar 2012 00:32:04 +0800
Message-ID: <1332433926-9132-1-git-send-email-mlin@ss.pku.edu.cn>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: =?UTF-8?q?J=F6rg=20Sommer?= <joerg@alea.gnuu.de>, Jeff Garzik <jgarzik@redhat.com>, Tejun Heo <tj@kernel.org>, Sergei Shtylyov <sshtylyov@mvista.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

These 2 patches fix bug report at:

http://marc.info/?l=linux-ide&m=133177818318187&w=2

Please see the patches for more detail.

[PATCH 1/2] [SCSI] scsi_lib: use correct DMA device in  __scsi_alloc_queue
[PATCH 2/2] libata: Pass correct DMA device to scsi host

Thanks,
Lin Ming
