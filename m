From: "=?ISO-8859-2?Q?V=E1clav_B=EDlek?=" <v.bilek@1art.cz>
Subject: unable to compile aic94xx-sas-2.6.git tree kernel
Date: Wed, 20 Sep 2006 14:09:44 +0200
Message-ID: <45112F88.6010708@1art.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.albatani.cz ([195.122.208.21]:35021 "EHLO ns.albatani.cz")
	by vger.kernel.org with ESMTP id S1751155AbWITMJ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Sep 2006 08:09:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Helo

I am trying to run a supermicro X7DB3 with adaptec 9410W and 9 sata
disks 8 on 9410W and 1 on onboard sata intel controler.

I did a git clone of
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/aic94xx-sas-2.6.git

but I am not able to compile it :(

when I do make mrproper; make menuconfig -> disable modular kernel;
enable  aic94xx, sata piix,and nic e1000 ;
make ...

i get :

drivers/scsi/scsi.c: In function `scsi_device_put':
drivers/scsi/scsi.c:880: warning: implicit declaration of function
`module_refcount'
.
.
.
.
  LD      drivers/built-in.o
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o(.text+0xb2be7): In function `scsi_device_put':
: undefined reference to `module_refcount'
drivers/built-in.o(.text+0xc7477): In function `asd_request_firmware':
: undefined reference to `request_firmware'
make: *** [.tmp_vmlinux1] Error 1


can anybody help me ?

Vaclav Bilek

