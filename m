From: egi <pfammatter-egi@swissonline.ch>
Subject: LSIFC909 problem
Date: Sun, 21 Oct 2007 09:33:52 +0200
Message-ID: <1192952032.16384.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:4098 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750738AbXJUHeF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Oct 2007 03:34:05 -0400
Received: from [192.168.1.5] (really [84.73.223.163])
          by viefep28-int.chello.at
          (InterMail vM.7.08.02.02 201-2186-121-104-20070414) with ESMTP
          id <20071021073357.QGKM16158.viefep28-int.chello.at@[192.168.1.5]>
          for <linux-scsi@vger.kernel.org>; Sun, 21 Oct 2007 09:33:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Since kenel > 2.6.8 my system doesn't regonize any more my FC-drives.
I installed latest kernel 2.6.23-git7 incl patch but no chance.
I get the following message during the boot:

Oct 21 08:57:06 localhost kernel: Fusion MPT base driver 3.04.05
Oct 21 08:57:06 localhost kernel: Copyright (c) 1999-2007 LSI Logic
Corporation
Oct 21 08:57:06 localhost kernel: Fusion MPT FC Host driver 3.04.05
Oct 21 08:57:06 localhost kernel: mptbase: Initiating ioc0 bringup
Oct 21 08:57:06 localhost kernel: ioc0: LSIFC909 B1:
Capabilities={Initiator,LAN}
Oct 21 08:57:06 localhost kernel: mptbase: ioc0: IOCStatus(0x0022):
Config Page Invalid Page: type=00h, page=02h, action=00h, form=00000000h
Oct 21 08:57:06 localhost kernel: mptbase: ioc0: IOCStatus(0x0022):
Config Page Invalid Page: type=09h, page=00h, action=00h, form=00000000h
Oct 21 08:57:06 localhost kernel: scsi0 : ioc0: LSIFC909 B1,
FwRev=01000000h, Ports=1, MaxQ=1023, IRQ=21
modules:

mptfc                  17508  0
mptscsih               32672  1 mptfc
mptbase                70112  2 mptfc,mptscsih
scsi_transport_fc      40548  1 mptfc


If I boot my system with kernel 2.6.8-rc2 the fc-drives are available.
But with Kernel > 2.6.8-rc2 nothing works any more.

Can someone help me?


