From: Martin.Budsjo@astrazeneca.com
Subject: SCSI lun scan on 2.4.18
Date: Tue, 10 Dec 2002 15:18:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <9F028CC77827D611ACEE0002A5F12F07199C24@semldsntmsx208.seml.astrazeneca.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sesosn11.seso.astrazeneca.net (sesosn11.seso.astrazeneca.net [192.168.199.18])
	by sesosn01.astrazeneca.com (8.12.3/8.12.3) with ESMTP id gBAEJRKJ015927
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2002 15:19:36 +0100 (MET)
Received: from sesosn21.seso.astrazeneca.net (sesosn21.seso.astrazeneca.net [192.71.145.181])
	by sesosn11.seso.astrazeneca.net (8.12.3/8.12.3/AZ-def_main_in.12.3.5) with ESMTP id gBAEIstr016457
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2002 15:18:55 +0100 (MET)
Received: from astra-cdc-x03.seso.astrazeneca.net (astra-cdc-x03.seso.astrazeneca.net [192.71.145.48])
	by sesosn21.seso.astrazeneca.net (8.10.1/8.10.1) with ESMTP id gBAEIsK09980
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2002 15:18:54 +0100 (MET)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi=20

Should the option CONFIG_SCSI_MULTI_LUN disable or interfere with the
/proc/scsi/scsi "add-single-device a b c d"  commands?

We tried two kernels, one without the CONFIG_SCSI_MULTI_LUN and now one=
 with
it enabled. Without the CONFIG_SCSI_MULTI_LUN we had no problem finding=
 new
devices on our SAN with the help of the /proc/scsi/scsi interface, but
devices did not get detected at boot. Now it find devices at boot, but =
seems
to ignore the "add-single-device" commands. ( except for one single lin=
e in
the messages file)

Is there any other way to force detection of new scsi devices?=20

Regards			Martin Budsj=F6
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
