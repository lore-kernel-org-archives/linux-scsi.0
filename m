From: Boaz Harrosh <bharrosh@panasas.com>
Subject: qla_sup.c: compilation warning
Date: Thu, 24 Jan 2008 18:43:33 +0200
Message-ID: <4798C035.5010000@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13508 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755930AbYAXQnj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jan 2008 11:43:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-driver@qlogic.com

With gcc 4.1.2 on fedora7 x86_64, cross compiling an i386 kernel i get
the following compilation warning:

CC [M] drivers/scsi/qla2xxx/qla_sup.o
/usr0/export/dev/bharrosh/git/pub/scsi-misc/drivers/scsi/qla2xxx/qla_su=
p.c: In function =E2=80=98qla2x00_beacon_blink=E2=80=99:
/usr0/export/dev/bharrosh/git/pub/scsi-misc/drivers/scsi/qla2xxx/qla_su=
p.c:906: warning: cast to pointer from integer of different size
/usr0/export/dev/bharrosh/git/pub/scsi-misc/drivers/scsi/qla2xxx/qla_su=
p.c: In function =E2=80=98qla2x00_beacon_on=E2=80=99:
/usr0/export/dev/bharrosh/git/pub/scsi-misc/drivers/scsi/qla2xxx/qla_su=
p.c:966: warning: cast to pointer from integer of different size
/usr0/export/dev/bharrosh/git/pub/scsi-misc/drivers/scsi/qla2xxx/qla_su=
p.c: In function =E2=80=98qla2x00_read_flash_byte=E2=80=99:
/usr0/export/dev/bharrosh/git/pub/scsi-misc/drivers/scsi/qla2xxx/qla_su=
p.c:1247: warning: cast to pointer from integer of different size
/usr0/export/dev/bharrosh/git/pub/scsi-misc/drivers/scsi/qla2xxx/qla_su=
p.c: In function =E2=80=98qla2x00_write_flash_byte=E2=80=99:
/usr0/export/dev/bharrosh/git/pub/scsi-misc/drivers/scsi/qla2xxx/qla_su=
p.c:1307: warning: cast to pointer from integer of different size

Perhaps the compiler is right this time ?
configured with: "make ARCH=3Di386 allmodconfig"

Boaz

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
