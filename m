From: =?iso-8859-1?Q?=22D=F6hr=2C_Markus_ICC-H=22?=
	<Markus.Doehr@siegenia-aubi.com>
Subject: RE: Help: strange messages from kernel on IA64 platform
Date: Tue, 16 May 2006 23:19:55 +0200
Message-ID: <FC7F4950D2B3B845901C3CE3A1CA6766015CC246@mxnd200-9.si-aubi.siegenia-aubi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.siegenia-aubi.com ([217.5.180.129]:12942 "EHLO
	alg-1.siegenia-aubi.com") by vger.kernel.org with ESMTP
	id S932065AbWEPVUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2006 17:20:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org

> During communication in between application and megaraid=20
> driver via IOCTL, the system displays messages which are not=20
> easy to track down.
> Following is one of the messages and same messages with=20
> different values are poping up regularly.
> ---
> Kernel unaligned access to 0xe00000007f3d80dc ip=3D0xa0000002000373b1
> ---

We have this message too on our main database server; the interesting p=
art
is, that the application, which triggers this error, is a database (Max=
DB)
and the process name is "kernel"... Just to avoid confusion: look if th=
ere's
an application with such name running on your system.


Greetz,


SIEGENIA-AUBI KG
Informationswesen
=20
i.A.
=20
Markus D=F6hr
SAP-CC/BC, SAPDB-DBA

Tel.:	 +49 6503 917-152
=46ax:	 +49 6503 917-7152
E-Mail: markus.doehr@siegenia-aubi.com
Internet: http://www.siegenia-aubi.com=20
 =20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
