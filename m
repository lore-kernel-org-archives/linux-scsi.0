From: aditya uttam <uttam.aditya@gmail.com>
Subject: Regarding #define SCSI_TIMEOUT
Date: Mon, 2 Nov 2009 20:34:53 +0530
Message-ID: <541bac340911020704n20484714u52aa388deac83667@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.216.179]:37604 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbZKBPEs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2009 10:04:48 -0500
Received: by pxi9 with SMTP id 9so3223069pxi.4
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2009 07:04:53 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear Experts,

To invoke my timeout function in my custom MS driver, what is the
least possible value that can set to #define SCSI_TIMEOUT (in
scsi_scan.c)?
Please let me know if the following process is correct to get the SCSI
layer with new SCSI_TIMEOUT value.

1.  Changed the #define SCSI_TIMEOUT (2*HZ) to least possible value in
scsi_scan.c
2.  Compiled the scsi and copied the .ko files to
/lib/modules/2.6.30/kernel/drivers/scsi/
3.  Created the new image by doing mkinitrd and added this image into
grub_config and booted from this image

Regards,
Aditya
