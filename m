From: <Bill.Hooper@Emulex.Com>
Subject: Controlling mpt2sas busy retries
Date: Tue, 2 Mar 2010 16:28:06 -0800
Message-ID: <02B16CD25461354295D12236BDA8C0E195BF0794FB@EXMAIL.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:42547 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751343Ab0CCAds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2010 19:33:48 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Bill.Hooper@Emulex.Com

I would like to control the number of times the mpt2sas driver retries a command on BUSY (I want to reduce the retry to zero or one). I found a document that explains I could use command_retry_count parameter when loading the driver, but the parameter does not exist for my driver. Any help would be appreciated.

Bill Hooper
Principal Software Engineer 
Emulex

root@spice (<-;)~ # uname -a
Linux spice 2.6.31-19-generic #56-Ubuntu SMP Thu Jan 28 01:26:53 UTC 2010 i686 GNU/Linux

root@spice (<-;)~ # modinfo mpt2sas
filename:       /lib/modules/2.6.31-19-generic/kernel/drivers/scsi/mpt2sas/mpt2sas.ko
version:        01.100.04.00
license:        GPL
description:    LSI MPT Fusion SAS 2.0 Device Driver
author:         LSI Corporation <DL-MPTFusionLinux@lsi.com>
srcversion:     65EA54D38B5A4AB0E385215
alias:          pci:v00001000d00000065sv*sd*bc*sc*i*
alias:          pci:v00001000d00000064sv*sd*bc*sc*i*
alias:          pci:v00001000d00000077sv*sd*bc*sc*i*
alias:          pci:v00001000d00000076sv*sd*bc*sc*i*
alias:          pci:v00001000d00000074sv*sd*bc*sc*i*
alias:          pci:v00001000d00000072sv*sd*bc*sc*i*
alias:          pci:v00001000d00000070sv*sd*bc*sc*i*
depends:        scsi_transport_sas
vermagic:       2.6.31-19-generic SMP mod_unload modversions 586 
parm:           logging_level: bits for enabling additional logging info (default=0)
parm:           max_lun: max lun, default=16895  (int)
parm:           max_queue_depth: max controller queue depth  (int)
parm:           max_sgl_entries: max sg entries  (int)
parm:           msix_disable: disable msix routed interrupts (default=0) (int)
