From: David Binderman <linuxdev.baldrick@gmail.com>
Subject: linux-4.8-rc1/drivers/scsi/sd.c:317: pointless test ?
Date: Mon, 8 Aug 2016 14:46:53 +0100
Message-ID: <CAMzoamaVuMxuXO8F3pxeR671eKAH-BZyxVDqU2F8jujHepK+5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35350 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbcHHNqz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2016 09:46:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dcb314@hotmail.com

Hello there,

linux-4.8-rc1/drivers/scsi/sd.c:317]: (style) Unsigned variable 'val'
can't be negative so it is unnecessary to test it.

Source code is

    if (val >= 0 && val <= SD_DIF_TYPE3_PROTECTION)

but

   unsigned int val;

Suggest new code

    if (val <= SD_DIF_TYPE3_PROTECTION)

Regards

David Binderman
