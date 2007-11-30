From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: LIO-VM Demo Images available for download!
Date: Fri, 30 Nov 2007 06:55:59 -0800
Message-ID: <1196434559.7468.18.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0742105643=="
Return-path: <ips-bounces@ietf.org>
List-Unsubscribe: <https://www1.ietf.org/mailman/listinfo/ips>,
	<mailto:ips-request@ietf.org?subject=unsubscribe>
List-Post: <mailto:ips@ietf.org>
List-Help: <mailto:ips-request@ietf.org?subject=help>
List-Subscribe: <https://www1.ietf.org/mailman/listinfo/ips>,
	<mailto:ips-request@ietf.org?subject=subscribe>
Errors-To: ips-bounces@ietf.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, Michael Brown <mbrown@fensystems.co.uk>, Mike Mazarick <mazarick@bellsouth.net>, LKML <linux-kernel@vger.kernel.org>, "Ross S. W. Walker" <rwalker@medallion.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Matthew Wilcox <willy@debian.org>, Mike Young <myoung@wildernessvoice.com>, "H. Peter Anvin" <hpa@zytor.com>, ips reflector <ips@ietf.org>, Open iSCSI <open-iscsi@googlegroups.com>, Robert Whitehead <WRWHITEHEAD@novell.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org


--===============0742105643==
Content-Type: multipart/alternative; boundary="=-8hnWZBlOBQ9Pwg5977DM"


--=-8hnWZBlOBQ9Pwg5977DM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Grettings all,

It is my great honor to announce that the LIO-VM Target images are now
online and available for download:

http://linux-iscsi.org/builds/LIO-VM/vmware/

and the wiki entry (which is basically the README now) is also online:

http://linux-iscsi.org/index.php/LIO-VM

Please check the wiki for the complete release information.  Here are
the bullets from the README.

Have Fun!!! :-)

--nab

----------------------------------------------------------------------------------------------------------------------------------

Introduction:

The LIO-VM Storage Engine demo is a set of  VMware compatible virtual
machine images that contains
a self-configuring iSCSI storage engine that runs on with a very large
and diverse amount of PC storage
software and hardware.  When the LIO-VM image boots, the host local
storage hardware that is made
available to the guest is exported as iSCSI target ports, and made
available to both local and remote
iSCSI Initiator clients.

Note that the iSCSI target is configured to allow _ALL_ iSCSI Initiators
to access _ALL_ iSCSI Target Ports
across all available iSCSI Network Portals.  By default, the storage
devices with filesystems will be exported
as READ-ONLY to prevent multiple accesses by non-cluster filesystems.
Support for production R/W
configurations of this demo are in the works, please stay tuned to the
site and lists for more information
as this unfolds.  Also, if you really know what you are doing when it
comes to non cluster filesystem + RW
access, please see section IX) below.

I) The .vmx LIO-VM images:

        There are two VMware Workstation 6.x/Fusion compatible image
available:

        Debian Etch 4 i386: (2.6.18-5-686)
        JeOS / Ubuntu 7.10 i386: (2.6.22-14-virtual)

II) What are the host OS requirements to run the LIO-VM Demo?

        Any i386 or x86_64 Linux v2.6 host that can run VMware
Workstation 6.
        Any Apple Mac-tel hardware that can run VMware Fusion.
        Any XP or NT compatible host that can run VMware Workstation 6.

III) What has been tested?

        The LIO-VM has been successfully run on Linux v2.6, MacOSX
Leopard, and WinXP/NT.

        USB connected flash and SATA/PATA devices.
        Internal SATA DVD and External SATA HD drives
        External USB DVD/HD devices are also supported.

IV) What should work?

        All USB Direct-Access (flash, USB external PATA/SATA disk
drives)
        All USB optical drives (CD, DVD, HD/DVD and BD)
        All PATA/SATA disk drives
        All PATA/SATA optical drives (CD, DVD, HD/DVD and BD)
        All PSCSI / FC / SAS hardware with correct host OS drivers.

        Basically, if it works locally, and you can bring it into the
guest,
        you can export it.

V) Why are there two images?

        The Debian image has a work around to allow optical devices to
work properly.
        Other than this difference, the two images should function as
identical for other
        devices, host OS storage driver requirements not withstanding.
See VI) for
        more information.


--=-8hnWZBlOBQ9Pwg5977DM
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/3.14.3">
</HEAD>
<BODY>
Grettings all,<BR>
<BR>
It is my great honor to announce that the LIO-VM Target images are now online and available for download:<BR>
<BR>
<A HREF="http://linux-iscsi.org/builds/LIO-VM/vmware/">http://linux-iscsi.org/builds/LIO-VM/vmware/</A><BR>
<BR>
and the wiki entry (which is basically the README now) is also online:<BR>
<BR>
<A HREF="http://linux-iscsi.org/index.php/LIO-VM">http://linux-iscsi.org/index.php/LIO-VM</A><BR>
<BR>
Please check the wiki for the complete release information.&nbsp; Here are the bullets from the README.<BR>
<BR>
Have Fun!!! :-)<BR>
<BR>
--nab<BR>
<BR>
----------------------------------------------------------------------------------------------------------------------------------<BR>
<BR>
Introduction:<BR>
<BR>
The LIO-VM Storage Engine demo is a set of&nbsp; VMware compatible virtual machine images that contains<BR>
a self-configuring iSCSI storage engine that runs on with a very large and diverse amount of PC storage<BR>
software and hardware.&nbsp; When the LIO-VM image boots, the host local storage hardware that is made<BR>
available to the guest is exported as iSCSI target ports, and made available to both local and remote<BR>
iSCSI Initiator clients.<BR>
<BR>
Note that the iSCSI target is configured to allow _ALL_ iSCSI Initiators to access _ALL_ iSCSI Target Ports<BR>
across all available iSCSI Network Portals.&nbsp; By default, the storage devices with filesystems will be exported<BR>
as READ-ONLY to prevent multiple accesses by non-cluster filesystems.&nbsp; Support for production R/W<BR>
configurations of this demo are in the works, please stay tuned to the site and lists for more information<BR>
as this unfolds.&nbsp; Also, if you really know what you are doing when it comes to non cluster filesystem + RW<BR>
access, please see section IX) below.<BR>
<BR>
I) The .vmx LIO-VM images:<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; There are two VMware Workstation 6.x/Fusion compatible image available:<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Debian Etch 4 i386: (2.6.18-5-686)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; JeOS / Ubuntu 7.10 i386: (2.6.22-14-virtual)<BR>
<BR>
II) What are the host OS requirements to run the LIO-VM Demo?<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Any i386 or x86_64 Linux v2.6 host that can run VMware Workstation 6.<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Any Apple Mac-tel hardware that can run VMware Fusion.<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Any XP or NT compatible host that can run VMware Workstation 6.<BR>
<BR>
III) What has been tested?<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; The LIO-VM has been successfully run on Linux v2.6, MacOSX Leopard, and WinXP/NT.<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; USB connected flash and SATA/PATA devices.<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Internal SATA DVD and External SATA HD drives<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; External USB DVD/HD devices are also supported.<BR>
<BR>
IV) What should work?<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; All USB Direct-Access (flash, USB external PATA/SATA disk drives)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; All USB optical drives (CD, DVD, HD/DVD and BD)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; All PATA/SATA disk drives<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; All PATA/SATA optical drives (CD, DVD, HD/DVD and BD)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; All PSCSI / FC / SAS hardware with correct host OS drivers.<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Basically, if it works locally, and you can bring it into the guest,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; you can export it.<BR>
<BR>
V) Why are there two images?<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; The Debian image has a work around to allow optical devices to work properly.<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Other than this difference, the two images should function as identical for other<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; devices, host OS storage driver requirements not withstanding.&nbsp; See VI) for<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; more information.<BR>
<BR>
</BODY>
</HTML>

--=-8hnWZBlOBQ9Pwg5977DM--




--===============0742105643==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ips mailing list
Ips@ietf.org
https://www1.ietf.org/mailman/listinfo/ips

--===============0742105643==--
