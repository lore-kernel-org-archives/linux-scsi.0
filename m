From: Jeff Garzik <jeff@garzik.org>
Subject: [SCSI] IPS bug found
Date: Sun, 01 Oct 2006 12:44:31 -0400
Message-ID: <451FF06F.5060100@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:13711 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751247AbWJAQod (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Oct 2006 12:44:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>

This gcc warning indicates a bug:

drivers/scsi/ips.c: In function =91ips_insert_device=92:
drivers/scsi/ips.c:7123: warning: =91index=92 may be used uninitialized=
 in=20
this function

ips_register_scsi() and ips_free() may be called on an uninitialized=20
'index', if the preceding functions fail.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
