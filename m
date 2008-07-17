From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ANNOUNCE] - VHACS-VM x86_64 Alpha Preview - FOLLOWUP
Date: Thu, 17 Jul 2008 10:44:57 -0700
Message-ID: <1216316697.7988.78.camel@haakon2.linux-iscsi.org>
References: <1216058533.21408.83.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:36178 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758059AbYGQRpD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2008 13:45:03 -0400
In-Reply-To: <1216058533.21408.83.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jerome Martin <tramjoe.merin@gmail.com>
Cc: Ming Zhang <blackmagic02881@gmail.com>, "Ross S. W. Walker" <rwalker@medallion.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@osdl.org>, Ted Ts'o <tytso@thunk.org>, Christoph Hellwig <hch@lst.de>, Mike Mazarick <mazarick@bellsouth.net>, Rafiu Fakunle <rafiu@openfiler.com>, Hannes Reinecke <hare@suse.de>, Grant Grundler <grundler@google.com>, "Love, Robert W" <robert.w.love@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Arjan van de Ven <arjan@infradead.org>, Andrew Beekhof <abeekhof@suse.de>, Michael Shiloh <michael@openmoko.org>, Bryan Black <bdblinux@gmail.com>, Sig Lange <sig.lange@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>

Greetings all,

Just a quick couple of updates since the VHACS-VM announcement (which
happened to be a day after after v2.6.26. ;):

I) The two VHACS-VM x86_64 images, have been split into 2 compressed
~300 MB images (for the running demo), and a 800 MB BUILD .vmdk disk
image containing the source for VHACS v0.8.15.  The three archives can
be found at the same location:

http://linux-iscsi.org/builds/VHACS-VM/x86_64/vmware6/

II) lio-core-2.6.git has been updated to v2.6.26 and loaded successfully
on 32-bit x86 VM.  Only a very minor change to get things compiled on
v2.6.26.  Please see

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

for more information.

III) VHACS-VM has now successfully been able to handle node failures and
restart failed cluster resource allocations (RA) on the active node,
across multiple platforms using x86_64 hardware virtualization.  :-)

Lots of things going on this week.  More to come soon.  Please keep
checking the http://Linux-iSCSI.org site for the latest information.

Many thanks for your most valuable of time,

--nab

On Mon, 2008-07-14 at 11:02 -0700, Nicholas A. Bellinger wrote:
> Greetings all,
> 
> I am pleased to announce the Alpha availibility of VHACS-VM Demo for
> Hardware Virtualized x86_64 running (initially) on VMWare Workstation 6.
> The VHACS cluster stack also obviously runs on 'bare-metal' hardware,
> but today VHACS-VM is the easiest method to get your own open storage
> cloud up and running.
> 
> What is VHACS..?
> 
> VHACS is a Cloud Storage implementation running on Linux v2.6. VHACS is
> an acrynom for Virtualization, High Availibility, and Cluster Storage.
> VHACS is a combination of at least eight (8) long term OSS/Linux based
> projects, along with a CLI management interface for controlling VHACS
> nodes, clouds, and vservers within the VHACS cluster.  Here is a quick
> rundown of the projects (so far) that make up the VHACS cluster stack:
> 
> CLUSTER:
> 
>       * ) Pacemaker The scalable High-Availability cluster resource
>         manager formerly part of Heartbeat
>       * ) OpenAIS The OpenAIS Standards Based Cluster Framework is an
>         OSI Certified implementation of the Service Availability Forum
>         Application Interface Specification (AIS)
> 
> SERVER:
> 
>       * ) LIO-Target w/ IBLOCK LIO-Core subsystem plugin for iSCSI
>         Target mode export
>       * ) DRBD Distributed Replicated Block device for Network RAID 1
>         Mirrors
>       * ) Linux Logical Volume Manager (LVM) ('vhacs' volume group for
>         creation of VHACS clouds)
> 
> CLIENT:
> 
>       * ) Open/iSCSI iSCSI Initiator client
>       * ) Ext3 filesystem
>       * ) Linux-Vserver Linux Virtualization Layer
> 
> I am happy to report that VHACS-VM Alpha Demo x86_64 is running 0.8.15
> VHACS code, along with the many other pieces of open source
> infrastructure that the VHACS cloud builds upon, and providing
> Active/Active H/A with Synchronous Data Replication iSCSI Target ERL=2 /
> MC/2 export that makes up the SERVER side of the VHACS cloud.  The
> CLIENT side of the VHACS cloud is also running an iSCSI Initiator ext3
> mounted filesystem with Open/iSCSI on top of Intel 45 nanometer
> 'Wolfdale' microprocessor silicon and DDR2 800 memory.
> 
> Futhermore, using commerically available x86 virtualization technology
> on open/closed platforms, I am very happy to report that VHACS-VM 2x
> node clusters are now up and running across both OPEN (Linux x86_64) and
> CLOSED (win32) x86 platforms on top of the 45nm chips with the VMMU/VMX
> parts enabled.  The first OS independent storage clouds running on top
> of v2.6.25.9-kdb are now a reality.
> 
> Here is a link to the code, screenshots, and all the goodies:
> 
> http://linux-iscsi.org/index.php/VHACS-VM
> http://linux-iscsi.org/index.php/VHACS
> 
> The VHACS-VM x86_64 system images, which contain a Debian Etch system
> iamges running the very latest compontents that make up the VHACS
> cluster stack.  Also included in the vhac64-west and vhacs64-east system
> images is a complete development environment, including a KDB enabled
> kernel that will allow the developer to pause the running image at any
> time, examine memory, or setup a breakpoint to track down a problem.
> The x86_64 system images currently require hardware x86 virtualization,
> please see the wiki for more information about hardware requirements.
> They are available from:
> 
> http://linux-iscsi.org/builds/VHACS-VM/x86_64/vmware6/
> 
> Also, there is great interest to see VHACS-VM running on KVM and QEMU
> Virtualization platforms.  This is something that should not be too
> difficult as long as the virtualization platform supports execution of
> x86_64 system images.  i386 system images are also in the works to bring
> the storage cloud to legacy environments without hardware x86_64
> virtualization.
> 
> Enjoy,
> 
> --nab
> 

