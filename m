From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: VHACS-VM x86_64 Alpha Preview on 45nm multicore
Date: Mon, 14 Jul 2008 11:02:13 -0700
Message-ID: <1216058533.21408.83.camel@haakon2.linux-iscsi.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi-help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi-unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Jerome Martin <tramjoe.merin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ming Zhang <blackmagic02881-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Ross S. W. Walker" <rwalker-gVKREKZ8iPqaMJb+Lgu22Q@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, FUJITA Tomonori <fuji>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Open iSCSI <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, OpenFabrics-General <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


Greetings all,

I am pleased to announce the Alpha availibility of VHACS-VM Demo for
Hardware Virtualized x86_64 running (initially) on VMWare Workstation 6.
The VHACS cluster stack also obviously runs on 'bare-metal' hardware,
but today VHACS-VM is the easiest method to get your own open storage
cloud up and running.

What is VHACS..?

VHACS is a Cloud Storage implementation running on Linux v2.6. VHACS is
an acrynom for Virtualization, High Availibility, and Cluster Storage.
VHACS is a combination of at least eight (8) long term OSS/Linux based
projects, along with a CLI management interface for controlling VHACS
nodes, clouds, and vservers within the VHACS cluster.  Here is a quick
rundown of the projects (so far) that make up the VHACS cluster stack:

CLUSTER:

      * ) Pacemaker The scalable High-Availability cluster resource
        manager formerly part of Heartbeat
      * ) OpenAIS The OpenAIS Standards Based Cluster Framework is an
        OSI Certified implementation of the Service Availability Forum
        Application Interface Specification (AIS)

SERVER:

      * ) LIO-Target w/ IBLOCK LIO-Core subsystem plugin for iSCSI
        Target mode export
      * ) DRBD Distributed Replicated Block device for Network RAID 1
        Mirrors
      * ) Linux Logical Volume Manager (LVM) ('vhacs' volume group for
        creation of VHACS clouds)

CLIENT:

      * ) Open/iSCSI iSCSI Initiator client
      * ) Ext3 filesystem
      * ) Linux-Vserver Linux Virtualization Layer

I am happy to report that VHACS-VM Alpha Demo x86_64 is running 0.8.15
VHACS code, along with the many other pieces of open source
infrastructure that the VHACS cloud builds upon, and providing
Active/Active H/A with Synchronous Data Replication iSCSI Target ERL=2 /
MC/2 export that makes up the SERVER side of the VHACS cloud.  The
CLIENT side of the VHACS cloud is also running an iSCSI Initiator ext3
mounted filesystem with Open/iSCSI on top of Intel 45 nanometer
'Wolfdale' microprocessor silicon and DDR2 800 memory.

Futhermore, using commerically available x86 virtualization technology
on open/closed platforms, I am very happy to report that VHACS-VM 2x
node clusters are now up and running across both OPEN (Linux x86_64) and
CLOSED (win32) x86 platforms on top of the 45nm chips with the VMMU/VMX
parts enabled.  The first OS independent storage clouds running on top
of v2.6.25.9-kdb are now a reality.

Here is a link to the code, screenshots, and all the goodies:

http://linux-iscsi.org/index.php/VHACS-VM
http://linux-iscsi.org/index.php/VHACS

The VHACS-VM x86_64 system images, which contain a Debian Etch system
iamges running the very latest compontents that make up the VHACS
cluster stack.  Also included in the vhac64-west and vhacs64-east system
images is a complete development environment, including a KDB enabled
kernel that will allow the developer to pause the running image at any
time, examine memory, or setup a breakpoint to track down a problem.
The x86_64 system images currently require hardware x86 virtualization,
please see the wiki for more information about hardware requirements.
They are available from:

http://linux-iscsi.org/builds/VHACS-VM/x86_64/vmware6/

Also, there is great interest to see VHACS-VM running on KVM and QEMU
Virtualization platforms.  This is something that should not be too
difficult as long as the virtualization platform supports execution of
x86_64 system images.  i386 system images are also in the works to bring
the storage cloud to legacy environments without hardware x86_64
virtualization.

Enjoy,

--nab
