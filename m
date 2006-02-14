From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: New Mega Raid Modules Problem
Date: Tue, 14 Feb 2006 06:38:10 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C265142084@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:7105 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1161046AbWBNNiZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2006 08:38:25 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fatih TURKMEN <fatih.turkmen@izmirekonomi.edu.tr>, "Kolli, Neela" <Neela.Kolli@engenio.com>
Cc: linux-scsi@vger.kernel.org

Hi,

Can you please specify what type of MegaRAID controllers in the system?
If you send me dmesg, it would help.

Thank you,=20

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org=20
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Fatih TURKMEN
> Sent: Tuesday, February 14, 2006 5:03 AM
> To: Kolli, Neela
> Cc: linux-scsi@vger.kernel.org
> Subject: New Mega Raid Modules Problem
>=20
> Dear Sir/Madam,
> I got your e-mail address from module maintainers list. I have 3 HP L=
H
> 6000 machines and want to install Linux on them. Everytime the instal=
l
> hangs on searching for info file phase (during the "megaraid:
> aborting-227170 cmd=3D28  megaraid abort: 227170:57[255:0], fw owner"=
).
>=20
> As I searched through the Internet, the old megaraid modules=20
> (in kernel
> 2.4) work fine with these devices. I could successfully=20
> install SUSE 8.0.
> But I tried SUSE 10, Mandriva 2006, Fedora 2.0  (kernel 2.6.*) and it
> hanged on at exactly the same phase.
>=20
> A quick advise to my problem was installing SUSE 8.0 and=20
> update everthing
> except megaraid modules. However I couldn't find an update=20
> for SUSE. Any
> advice about this appreciated.
>=20
> The questions are;
> 1) Is it a known issue?
> 2) What causes the new megaraid modules not to function on=20
> these machines?
> 3) Is there a tricky solution to this problem?
>=20
>=20
> Thanks in advance.
>=20
>=20
> --=20
> Fatih TURKMEN
> IUE Faculty of Computer Sciences
> --------------------------------------------------------------
> ---------
>=20
> Uyar=FD
> Bu e-posta sadece yukar=FDda isimleri belirtilen ki=FEiler aras=FDnda=
 =F6zel=20
> haberle=FEme amac=FDn=FD ta=FE=FDmaktad=FDr. Size yanl=FD=FEl=FDkla u=
la=FEm=FD=FEsa l=FCtfen=20
> g=F6nderen ki=FEiyi bilgilendiriniz ve mesaj=FD sisteminizden siliniz=
=2E=20
> =DDzmir Ekonomi =DCniversitesi bu mesaj=FDn i=E7eri=F0i ile ilgili=20
> olarak hi=E7bir=20
> hukuksal sorumlulu=F0u kabul etmez.=20
>=20
> Disclaimer
> This e-mail communication is intended for the private use of=20
> the sender=20
> and the recepients named above. If you received this message=20
> in error,=20
> please immediately notify the sender and delete it from your system. =
=20
> Izmir University of Economics does not accept legal=20
> responsibility for=20
> the contents of this message=20
>=20
> --------------------------------------------------------------
> ---------
> -
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
