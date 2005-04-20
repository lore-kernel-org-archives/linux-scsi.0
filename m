From: oliver@windfinder.com
Subject: Raid1 on Dell Poweredge with Perc4e/Di Raid Controller running Debian Sarge (3.1)
Date: Wed, 20 Apr 2005 13:22:45 +0200
Message-ID: <200504201322.50066.oliver@windfinder.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.windfinder.de ([81.201.107.60]:44479 "HELO windfinder.com")
	by vger.kernel.org with SMTP id S261328AbVDTLXb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 07:23:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt_Domsch@dell.com, linux-poweredge@dell.com, linux-scsi@vger.kernel.org, Thomas Glas <thomas.glas@hanse.net>

Hello,
I would like to use Raid1 on the Dell Poweredge with Perc4e/Di Raid Con=
troller=20
and two 2 73 GB drives running Debian Sarge (3.1).

At http://linux.dell.com/storage.shtml I read that the Powerege 2850 Pe=
rc4e/Di=20
requires megaraid2 driver 2.00.3 or higher on 2.4.x kernel. On 2.6.x ke=
rnels=20
(x < 9) there is no driver for these adapters. On 2.6.x (x >=3D 9) use =
the=20
'megaraid_mbox' and 'megaraid_mm' drivers.

Problem: The Debian Installers offers only to install:

- 2.4.x (which seems to be okay for the raid) OR=20
- 2.6.8 (which would not allow the use of the Raid)

Solution:
Is there a megaraid driver for the 2.6.8 kernel? If so, where?

If not, should I use 2.4.x kernel or try to install a 2.6.9 kernel on D=
ebian=20
Sarge?

Regards,

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
