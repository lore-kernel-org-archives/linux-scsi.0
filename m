From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: RE: Help: strange messages from kernel on IA64 platform
Date: Tue, 16 May 2006 14:38:42 -0700
Message-ID: <4t153d$13lgbu@azsmga001.ch.intel.com>
References: <FC7F4950D2B3B845901C3CE3A1CA6766015CC246@mxnd200-9.si-aubi.siegenia-aubi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63406 "EHLO
	azsmga101-1.ch.intel.com") by vger.kernel.org with ESMTP
	id S932081AbWEPVis convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2006 17:38:48 -0400
In-Reply-To: <FC7F4950D2B3B845901C3CE3A1CA6766015CC246@mxnd200-9.si-aubi.siegenia-aubi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?'=22D=F6hr=2C_Markus_ICC-H=22'?= <Markus.Doehr@siegenia-aubi.com>, "Ju, Seokmann" <Seokmann.Ju@lsil.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org

D=F6hr, Markus ICC-H wrote on Tuesday, May 16, 2006 2:20 PM
> > During communication in between application and megaraid=20
> > driver via IOCTL, the system displays messages which are not=20
> > easy to track down.
> > Following is one of the messages and same messages with=20
> > different values are poping up regularly.
> > ---
> > Kernel unaligned access to 0xe00000007f3d80dc ip=3D0xa0000002000373=
b1
> > ---
>=20
> We have this message too on our main database server; the interesting=
 part
> is, that the application, which triggers this error, is a database (M=
axDB)
> and the process name is "kernel"... Just to avoid confusion: look if =
there's
> an application with such name running on your system.

Unaligned access warning for user space process will print in a slightl=
y
different format.  It will print process name and its pid, something li=
ke:

cgc(15270): unaligned access to 0x20000000002b8025, ip=3D0x400000000000=
0b21

(you can also make the differentiation by looking at the data and instr=
uction
 address).

- Ken
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
