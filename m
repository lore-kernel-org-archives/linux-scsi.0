From: Jeff Garzik <jeff@garzik.org>
Subject: SCSI make all{yes,mod}config build breakage
Date: Sat, 30 Sep 2006 21:25:40 -0400
Message-ID: <451F1914.9040007@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55785 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751881AbWJABZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Sep 2006 21:25:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

The block tree merge broke the SCSI build:

   CC [M]  drivers/scsi/libsas/sas_scsi_host.o
In file included from include/scsi/libsas.h:35,
                  from drivers/scsi/libsas/sas_internal.h:32,
                  from drivers/scsi/libsas/sas_scsi_host.c:26:
include/scsi/scsi_device.h: In function =91scsi_device_reprobe=92:
include/scsi/scsi_device.h:303: warning: ignoring return value of=20
=91device_reprobe=92, declared with attribute warn_unused_result
drivers/scsi/libsas/sas_scsi_host.c: In function =91sas_scsi_get_task_a=
ttr=92:
drivers/scsi/libsas/sas_scsi_host.c:129: error: =91struct request=92 ha=
s no=20
member named =91flags=92

The attached patch (sent in separate email with proper sign-off) fixes=20
things.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
