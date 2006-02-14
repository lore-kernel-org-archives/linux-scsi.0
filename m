From: "Fatih TURKMEN" <fatih.turkmen@izmirekonomi.edu.tr>
Subject: New Mega Raid Modules Problem
Date: Tue, 14 Feb 2006 12:03:11 +0200 (EET)
Message-ID: <1634.172.16.3.169.1139911391.squirrel@webmail.ieu.edu.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from em1.izmirekonomi.edu.tr ([193.255.108.20]:6353 "EHLO
	em1.ieu.edu.tr") by vger.kernel.org with ESMTP id S1030347AbWBNKNb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2006 05:13:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela.Kolli@engenio.com
Cc: linux-scsi@vger.kernel.org

Dear Sir/Madam,
I got your e-mail address from module maintainers list. I have 3 HP LH
6000 machines and want to install Linux on them. Everytime the install
hangs on searching for info file phase (during the "megaraid:
aborting-227170 cmd=3D28  megaraid abort: 227170:57[255:0], fw owner").

As I searched through the Internet, the old megaraid modules (in kernel
2.4) work fine with these devices. I could successfully install SUSE 8.=
0.
But I tried SUSE 10, Mandriva 2006, Fedora 2.0  (kernel 2.6.*) and it
hanged on at exactly the same phase.

A quick advise to my problem was installing SUSE 8.0 and update everthi=
ng
except megaraid modules. However I couldn't find an update for SUSE. An=
y
advice about this appreciated.

The questions are;
1) Is it a known issue?
2) What causes the new megaraid modules not to function on these machin=
es?
3) Is there a tricky solution to this problem?


Thanks in advance.


--=20
=46atih TURKMEN
IUE Faculty of Computer Sciences
-----------------------------------------------------------------------

Uyar=FD
Bu e-posta sadece yukar=FDda isimleri belirtilen ki=FEiler aras=FDnda =F6=
zel=20
haberle=FEme amac=FDn=FD ta=FE=FDmaktad=FDr. Size yanl=FD=FEl=FDkla ula=
=FEm=FD=FEsa l=FCtfen=20
g=F6nderen ki=FEiyi bilgilendiriniz ve mesaj=FD sisteminizden siliniz.=20
=DDzmir Ekonomi =DCniversitesi bu mesaj=FDn i=E7eri=F0i ile ilgili olar=
ak hi=E7bir=20
hukuksal sorumlulu=F0u kabul etmez.=20

Disclaimer
This e-mail communication is intended for the private use of the sender=
=20
and the recepients named above. If you received this message in error,=20
please immediately notify the sender and delete it from your system. =20
Izmir University of Economics does not accept legal responsibility for=20
the contents of this message=20

-----------------------------------------------------------------------
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
