From: oliver@windfinder.com
Subject: Install dellomsa-drivers and dellomsa on Debian Sarge Kernel 2.4.27
Date: Thu, 21 Apr 2005 18:51:18 +0200
Message-ID: <200504211851.19170.oliver@windfinder.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.windfinder.de ([81.201.107.60]:18881 "HELO windfinder.com")
	by vger.kernel.org with SMTP id S261548AbVDUQwB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2005 12:52:01 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aschultz@warp10.net, Matt_Domsch@dell.com, linux-poweredge@dell.com, linux-scsi@vger.kernel.org
Cc: Thomas Glas <thomas.glas@hanse.net>, Jonas Kaufmann <me@j0nes.de>

Hello,
I have a Dell Poweredge 2850 running Debian Sarge Kernel 2.4.27. I down=
loaded=20
from: http://www.domsch.com/linux/openmanage-contrib/debian/ the Debian=
=20
packages:
dellomsa-drivers_4.90-3825_i386.deb
dellomsa_4.90-3825_i386.deb

and followed the instructions at:=20
http://lists.us.dell.com/fom-serve/cache/73.html

> added to /etc/snmp/snmpd.conf for
>  the dellomsa snmp subagent:
>
> # Allow Dell OpenManage Server Agent to connect to ucd-snmp using SMU=
X.
> smuxpeer .1.3.6.1.4.1.674.10892.1
Done!

server:~ # apt-get install kernel-source-2.4.27
server:~ # mv kernel-source-2.4.27 /usr/src/linux

> Installation:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1. install Dell's OMSA Agents,
>      see http://www.domsch.com/linux/openmanage-contrib/debian/

server:~# apt-get install dellomsa-drivers
=2E..
Building device driver for running kernel [FAILED]

Needed kernel source files are not installed.
See dynamic kernel support in the Server Administrator readmet.txt file=
=2E

Run rpm using the -e option to celan up the RPM database. Enter:
rpm- e dellomsa-drivers-4.90-3824

dpkg: Error editing dellomsa-drivers (--configure):
sub process post-installation script returned error code 41
Error ocuured when editing:
dellomsa-drivers
E: Sub-process /usr/bin/dpkg returned an error code (1)

What am I doing wrong? Please help! Thanks!

--=20
Oliver K=F6nig

Windfinder.com
Knorrstr. 24 Hinterhaus
24106 Kiel
Germany
phone +49 431-8008643
VoIP +49 1801-7775558229
fax +49 431-8008644
Mobile +49 177-4933362
oliver@windfinder.com
www.windfinder.com
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
