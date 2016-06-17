From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] VMW_PVSCSI: Change to update maintainer details (name,
 email)
Date: Fri, 17 Jun 2016 11:06:33 -0700
Message-ID: <1466186793.19647.113.camel@perches.com>
References: <57634CBD.8000402@vmware.com>
	 <CAGRGNgVK_xMmCQFHhhJ9E1frzTE--ivX1Po19O_qUjgYtuUK7A@mail.gmail.com>
	 <1466128907097.81812@vmware.com>
	 <CAGRGNgX=ec9m=zene34Lbp0Gn23jSjwyeqaGaG7jGYXnRy6hFg@mail.gmail.com>
	 <1466130787.19647.100.camel@perches.com>
	 <CAGRGNgXAgxMn9ChiVvcw+02ugEEKZh7WtXt2dLU-TegM-0_qKA@mail.gmail.com>
	 <1466132688.19647.105.camel@perches.com>
	 <CAGRGNgXGxFdzE4fdEzr2iPRX0DPN9JNZcC8HNTt-jW6iNyMqnQ@mail.gmail.com>
	 <A8B2C362-17B7-40ED-B71F-7A1868D9A080@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <A8B2C362-17B7-40ED-B71F-7A1868D9A080@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jim Gill <jgill@vmware.com>, Julian Calaby <julian.calaby@gmail.com>
Cc: Arvind Kumar <arvindkumar@vmware.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-06-17 at 17:44 +0000, Jim Gill wrote:
> On 6/16/16, 8:11 PM, "Julian Calaby" <julian.calaby@gmail.com> wrote:
>=20
>=20
>=20
> >=20
> > []
> >=20
> > >=20
> > > >=20
> > > > On Fri, Jun 17, 2016 at 12:33 PM, Joe Perches <joe@perches.com>=
 wrote:
> > > []
> > > The question to me is whether or not Jim Gill is
> > > taking over the maintainership of the entire
> > > VMware PVSCSI driver or just a few files of it.
> > As I see it, he's taking over maintainership of all of it: it's onl=
y
> > files are drivers/scsi/vmw_pvscsi.[ch] AFAIK.
> This is correct, I am taking over maintainership of the entire vmw_pv=
scsi driver.

Perhaps a patch like this:

=46rom e727c6549e3be466ec3c79e919502cb0b9909b03 Mon Sep 17 00:00:00 200=
1
Message-Id: <e727c6549e3be466ec3c79e919502cb0b9909b03.1466186573.git.jo=
e@perches.com>
=46rom: Joe Perches <joe@perches.com>
Date: Fri, 17 Jun 2016 10:56:49 -0700
Subject: [PATCH] vmw_pvscsi: Move into separate directory, Jim Gill is=A0=
MAINTAINER

Separate directories for drivers are generally better.

Miscellanea:

o Update the MAINTAINER entry
o Remove maintainer and FSF addresses from driver files
---
=A0MAINTAINERS=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0| 5 ++---
=A0drivers/scsi/Kconfig=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0| 8 +-------
=A0drivers/scsi/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0| 2 +-
=A0drivers/scsi/vmware/Kconfig=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0| 7 +=
++++++
=A0drivers/scsi/vmware/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0| 1 +
=A0drivers/scsi/{ =3D> vmware}/vmw_pvscsi.c | 7 -------
=A0drivers/scsi/{ =3D> vmware}/vmw_pvscsi.h | 7 -------
=A07 files changed, 12 insertions(+), 25 deletions(-)
=A0create mode 100644 drivers/scsi/vmware/Kconfig
=A0create mode 100644 drivers/scsi/vmware/Makefile
=A0rename drivers/scsi/{ =3D> vmware}/vmw_pvscsi.c (99%)
=A0rename drivers/scsi/{ =3D> vmware}/vmw_pvscsi.h (98%)

diff --git a/MAINTAINERS b/MAINTAINERS
index d174e34..2763582 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12421,12 +12421,11 @@ S:	Maintained
=A0F:	drivers/net/vmxnet3/
=A0
=A0VMware PVSCSI driver
-M:	Arvind Kumar <arvindkumar@vmware.com>
+M:	Jim Gill <jgill@vmware.com>
=A0M:	VMware PV-Drivers <pv-drivers@vmware.com>
=A0L:	linux-scsi@vger.kernel.org
=A0S:	Maintained
-F:	drivers/scsi/vmw_pvscsi.c
-F:	drivers/scsi/vmw_pvscsi.h
+F:	drivers/scsi/vmware/
=A0
=A0VOLTAGE AND CURRENT REGULATOR FRAMEWORK
=A0M:	Liam Girdwood <lgirdwood@gmail.com>
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 1918f54..339c230 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -576,13 +576,7 @@ config SCSI_FLASHPOINT
=A0	=A0=A0substantial, so users of MultiMaster Host Adapters may not
=A0	=A0=A0wish to include it.
=A0
-config VMWARE_PVSCSI
-	tristate "VMware PVSCSI driver support"
-	depends on PCI && SCSI && X86
-	help
-	=A0=A0This driver supports VMware's para virtualized SCSI HBA.
-	=A0=A0To compile this driver as a module, choose M here: the
-	=A0=A0module will be called vmw_pvscsi.
+source "drivers/scsi/vmware/Kconfig"
=A0
=A0config XEN_SCSI_FRONTEND
=A0	tristate "XEN SCSI frontend driver"
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 862ab4e..6cfefaa 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -141,7 +141,7 @@ obj-$(CONFIG_BE2ISCSI)		+=3D libiscsi.o be2iscsi/
=A0obj-$(CONFIG_SCSI_ESAS2R)	+=3D esas2r/
=A0obj-$(CONFIG_SCSI_PMCRAID)	+=3D pmcraid.o
=A0obj-$(CONFIG_SCSI_VIRTIO)	+=3D virtio_scsi.o
-obj-$(CONFIG_VMWARE_PVSCSI)	+=3D vmw_pvscsi.o
+obj-$(CONFIG_VMWARE_PVSCSI)	+=3D vmware/
=A0obj-$(CONFIG_XEN_SCSI_FRONTEND)	+=3D xen-scsifront.o
=A0obj-$(CONFIG_HYPERV_STORAGE)	+=3D hv_storvsc.o
=A0obj-$(CONFIG_SCSI_WD719X)	+=3D wd719x.o
diff --git a/drivers/scsi/vmware/Kconfig b/drivers/scsi/vmware/Kconfig
new file mode 100644
index 0000000..3c0c53b
--- /dev/null
+++ b/drivers/scsi/vmware/Kconfig
@@ -0,0 +1,7 @@
+config VMWARE_PVSCSI
+	tristate "VMware PVSCSI driver support"
+	depends on PCI && SCSI && X86
+	help
+	=A0=A0This driver supports VMware's para virtualized SCSI HBA.
+	=A0=A0To compile this driver as a module, choose M here: the
+	=A0=A0module will be called vmw_pvscsi.
diff --git a/drivers/scsi/vmware/Makefile b/drivers/scsi/vmware/Makefil=
e
new file mode 100644
index 0000000..ae8d278
--- /dev/null
+++ b/drivers/scsi/vmware/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VMWARE_PVSCSI)=A0=A0=A0=A0+=3D vmw_pvscsi.o
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmware/vmw_pvscsi=
=2Ec
similarity index 99%
rename from drivers/scsi/vmw_pvscsi.c
rename to drivers/scsi/vmware/vmw_pvscsi.c
index 6164634..eb1229e 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmware/vmw_pvscsi.c
@@ -12,13 +12,6 @@
=A0 * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE o=
r
=A0 * NON INFRINGEMENT.=A0=A0See the GNU General Public License for mor=
e
=A0 * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-130=
1 USA.
- *
- * Maintained by: Arvind Kumar <arvindkumar@vmware.com>
- *
=A0 */
=A0
=A0#include <linux/kernel.h>
diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmware/vmw_pvscsi=
=2Eh
similarity index 98%
rename from drivers/scsi/vmw_pvscsi.h
rename to drivers/scsi/vmware/vmw_pvscsi.h
index 12712c9..5f675b9 100644
--- a/drivers/scsi/vmw_pvscsi.h
+++ b/drivers/scsi/vmware/vmw_pvscsi.h
@@ -12,13 +12,6 @@
=A0 * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE o=
r
=A0 * NON INFRINGEMENT.=A0=A0See the GNU General Public License for mor=
e
=A0 * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-130=
1 USA.
- *
- * Maintained by: Arvind Kumar <arvindkumar@vmware.com>
- *
=A0 */
=A0
=A0#ifndef _VMW_PVSCSI_H_
--=A0
2.8.0.rc4.16.g56331f8
