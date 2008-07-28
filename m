From: David Miller <davem@davemloft.net>
Subject: Build fallout from scsi merge...
Date: Sun, 27 Jul 2008 17:04:15 -0700 (PDT)
Message-ID: <20080727.170415.12257647.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758752AbYG1AE0@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


>From allmodconfig on sparc64:

drivers/scsi/qla2xxx/qla_attr.c: In function 'qla24xx_vport_delete':
drivers/scsi/qla2xxx/qla_attr.c:1184: error: implicit declaration of function 'msleep'
make[3]: *** [drivers/scsi/qla2xxx/qla_attr.o] Error 1
make[3]: *** Waiting for unfinished jobs....
