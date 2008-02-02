From: maximilian attems <max@stro.at>
Subject: lpfc build failure in latest git
Date: Sat, 2 Feb 2008 15:36:13 +0100
Message-ID: <20080202143613.GA4941@stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:46401 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYBBOgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Feb 2008 09:36:48 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

  CC [M]  drivers/scsi/lpfc/lpfc_init.o
  drivers/scsi/lpfc/lpfc_init.c: In function =E2=80=98lpfc_pci_probe_on=
e=E2=80=99:
  drivers/scsi/lpfc/lpfc_init.c:1897: error: implicit declaration of fu=
nction =E2=80=98pci_enable_device_bars=E2=80=99
  make[6]: *** [drivers/scsi/lpfc/lpfc_init.o] Error 1

seen on both x86 archs.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
