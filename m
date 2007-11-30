From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: LIO-VM Demo Images available for download!
Date: Fri, 30 Nov 2007 07:03:14 -0800
Message-ID: <1196434994.7468.22.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:31558 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932808AbXK3PDQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Nov 2007 10:03:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, iet-dev <iscsitarget-devel@lists.sourceforge.net>

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

-----------------------------------------------------------------------

Introduction:

The LIO-VM Storage Engine demo is a set of  VMware compatible virtual
machine images that contains a self-configuring iSCSI storage engine
that runs on with a very large and diverse amount of PC storage
software and hardware.  When the LIO-VM image boots, the host local
storage hardware that is made available to the guest is exported as
iSCSI target ports, and made available to both local and remote
iSCSI Initiator clients.

Note that the iSCSI target is configured to allow _ALL_ iSCSI Initiators
to access _ALL_ iSCSI Target Ports across all available iSCSI Network
Portals.  By default, the storage devices with filesystems will be
exported as READ-ONLY to prevent multiple accesses by non-cluster
filesystems.  Support for production R/W configurations of this demo are
in the works, please stay tuned to the site and lists for more
information as this unfolds.  Also, if you really know what you are
doing when it comes to non cluster filesystem + RW access, please see
section IX) below.

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
	guest,  you can export it.

V) Why are there two images?

        The Debian image has a work around to allow optical devices to 
	work properly.  Other than this difference, the two images 
	should function as identical for other devices, host OS storage 
	driver requirements not withstanding.  See VI) for more 
	information.


