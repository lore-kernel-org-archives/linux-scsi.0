From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Subject: puzzling scsi return code 20000
Date: Mon, 05 Jul 2004 14:07:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40E9448F.1090700@univ-nantes.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from feyd.cri.univ-nantes.fr ([193.52.125.55]:9942 "EHLO
	smtp.cri.univ-nantes.fr") by vger.kernel.org with ESMTP
	id S266058AbUGEMHm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jul 2004 08:07:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.cri.univ-nantes.fr (Postfix) with ESMTP id 9DA28E0B740
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jul 2004 14:07:41 +0200 (CEST)
Received: from smtp.cri.univ-nantes.fr ([127.0.0.1])
	by localhost (smtp.cri.univ-nantes.fr [193.52.125.55]) (amavisd-new, port 10024)
	with LMTP id 10070-04-2 for <linux-scsi@vger.kernel.org>;
	Mon, 5 Jul 2004 14:07:40 +0200 (CEST)
Received: from [193.52.125.24] (lamier.cri.univ-nantes.fr [193.52.125.24])
	by smtp.cri.univ-nantes.fr (Postfix) with ESMTP id E160AE0B73F
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jul 2004 14:07:40 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

hello. I have some problems with a SAN here. Don't know if the problems=
=20
lies in scsi code/driver or other thing...

The setup is :
a QLA2300 (Fibre channel) with 6.0.64 driver from qlogic site,
2.4.26 kernel, device mapper 1.0.17 applied,
and xfs or reiserfs on top of lvm volumes (using evms)

This setup seemed fine since some months now, with giga of data moved=20
every day, but I noticed this on the log:

Jun 22 16:45:15 talisker kernel: SCSI disk error : host 3 channel 0 id =
2=20
lun 1 return code =3D 20000
Jun 22 16:45:15 talisker kernel:  I/O error: dev 08:10, sector 14542331=
2

I have two of these errors in the last month. What's the meaning of thi=
s=20
return code ? I made
badblock on the /dev/evms volume, and all is OK.

I also performed a disk scan on the raid array, (an IFT 7250F) and ther=
e=20
are no errors.

The machine can be quite heavily loaded. May I suspect the qla driver ?=
=20
May I suspect the underlying LVM. The LVM has been resized by the=20
past... Can an error happens here too ?
I'm very puzzled...

This is just a summary . I can furnish more information if needed.

--=20
Yann Dupont, Cri de l'universit=E9 de Nantes
Tel: 02.51.12.53.91 - Fax: 02.51.12.58.60 - Yann.Dupont@univ-nantes.fr


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
