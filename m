From: oliver@windfinder.com
Subject: Raid1 on Dell Poweredge with Perc4e/Di Raid Controller running Debian
	Sarge (3.1)
Date: Thu, 21 Apr 2005 10:30:55 +0200
Message-ID: <200504211030.56948.oliver@windfinder.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-poweredge-bounces@dell.com>
Content-Disposition: inline
List-Unsubscribe: <http://lists.us.dell.com/mailman/listinfo/linux-poweredge>,
	<mailto:linux-poweredge-request@dell.com?subject=unsubscribe>
List-Archive: <http://lists.us.dell.com/pipermail/linux-poweredge>
List-Post: <mailto:linux-poweredge@dell.com>
List-Help: <mailto:linux-poweredge-request@dell.com?subject=help>
List-Subscribe: <http://lists.us.dell.com/mailman/listinfo/linux-poweredge>,
	<mailto:linux-poweredge-request@dell.com?subject=subscribe>
Sender: linux-poweredge-bounces@dell.com
Errors-To: linux-poweredge-bounces@dell.com
To: Matt_Domsch@dell.com, linux-poweredge@dell.com, linux-scsi@vger.kernel.org
Cc: Thomas Glas <thomas.glas@hanse.net>
List-Id: linux-scsi@vger.kernel.org

Hello,
I would like to use Raid1 on the Dell Poweredge with Perc4e/Di Raid Control=
ler =

and two 2 73 GB drives running Debian Sarge (3.1).

At http://linux.dell.com/storage.shtml I read that the Powerege 2850 Perc4e=
/Di =

requires megaraid2 driver 2.00.3 or higher on 2.4.x kernel. On 2.6.x kernel=
s =

(x < 9) there is no driver for these adapters. On 2.6.x (x >=3D 9) use the =

'megaraid_mbox' and 'megaraid_mm' drivers.

Problem: The Debian Installers offers only to install:

- 2.4.x (which seems to be okay for the raid) OR =

- 2.6.8 (which would not allow the use of the Raid)

Solution:
Is there a megaraid driver for the 2.6.8 kernel? If so, where?

If not, should I use 2.4.x kernel or try to install a 2.6.9 kernel on Debia=
n =

Sarge?

-- =

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

_______________________________________________
Linux-PowerEdge mailing list
Linux-PowerEdge@dell.com
http://lists.us.dell.com/mailman/listinfo/linux-poweredge
Please read the FAQ at http://lists.us.dell.com/faq
