From: "Zuylen, G. van" <GvZuylen@ysl.nl>
Subject: Problems with higher SCSI LUN's with SLES8
Date: Thu, 4 Sep 2003 09:48:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A00BBCF927F25E4A9D5F6EE1380CDEF2CC88@hedwig.ysl.nl>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [62.58.77.3] ([62.58.77.3]:14094 "HELO hedwig.ysl.nl")
	by vger.kernel.org with SMTP id S264841AbTIDHs0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2003 03:48:26 -0400
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Hi you all,

We are using a HP DL380 server with a Qlogic 2300 HBA adapter. This adapter
is connected to a HP EMA12000 SAN (with HSG80 controllers). Behind the HBA
(qlogic 2300) we see only the devices up to LUN 7, higher LUN are not
detected. We have tried several things like modifying /etc/modules.conf with
"options scsi_mod max_scsi_luns=128" and modifying /boot/grub/menu.lst. But
nothing seems to be working.
We are using SLES8 with kernel version k_smp-2.4.19-304 and the qlogic
driver version 6.05.60. Also tested with a newer kernel k_smp-2.4.19-340,
but this makes no difference. 

Does anybody know how we can solve this problem or is there somebody who has
experience with this ?

Best regards,

Gert van Zuylen

