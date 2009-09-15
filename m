From: "Isabelle, Francois" <Francois.Isabelle@ca.kontron.com>
Subject: mptsas/iommu/pciehp : PCIe hotplug of LSISAS1064E  fails with intel_iommu=on
Date: Tue, 15 Sep 2009 09:07:59 -0400
Message-ID: <C2866F9FC4CB034EB51A633DF168598605D69672@ssbarcelone>
References: <C2866F9FC4CB034EB51A633DF168598605D68925@ssbarcelone> <20090911163933.GC2907@lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-pci-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: linux-pci@vger.kernel.org, DL-MPTFusionLinux@lsi.com, Grant Grundler <grundler@parisc-linux.org>
List-Id: linux-scsi@vger.kernel.org

Hi.

An issue has been raised with the SAS1064E when used on an Intel 5520 p=
latform: pcie hot-plug of the controller does not work.

Since I can't access the archive for 'DL-MPTFusionLinux@lsi.com' and si=
nce I didn't receive a reply from MPTFusion list yet, I'm posting the t=
hread here. It seems to be the right place to discuss MPT fusion driver=
 anyways.

It appears that the MPT driver misbehaves; I'd like to know if there ar=
e any success stories when mixing VT-d technology with PCIe hot plug on=
 a similar platform.

Instead of duplicating the whole thread I'm sending these links to the =
original posts.

http://marc.info/?l=3Dlinux-pci&m=3D125252723005873&w=3D2 [original pos=
t]
http://marc.info/?l=3Dlinux-pci&m=3D125268717610600&w=3D2 [reply]
http://marc.info/?l=3Dlinux-pci&m=3D125268984516738&w=3D2 [follow up po=
st]

I'm also reposting to IOMMU list with a new 'topic' line that might be =
more meaningful.=20

Thank you.

=46ran=E7ois Isabelle | Software Designer | Kontron Canada | T 450 437 =
5682 |F 450 437 8053 | E francois.isabelle@ca.kontron.com
=20
