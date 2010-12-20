From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 0/7] SCST: A Generic SCSI Target Subsystem
Date: Mon, 20 Dec 2010 18:47:29 +0100
Message-ID: <201012201847.29357.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: James.Bottomley-l3A5Bk7waGM@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

During LinuxCon 2010 the following acceptance criteria have been defined for
an in-kernel storage target:

    1. Being a drop in replacement for STGT (the current
       in-kernel target mode driver), since only a single
       SCSI target infrastructure is desired.

    2. Using a modern sysfs based control and configuration plane.

    3. That the code was reviewed as clean enough for inclusion.

We believe that SCST meets (1) and (2), and hereby kindly ask either to
review the SCST code further or to merge it in the upstream kernel.

The current patch set consists of seven patches:

0001-block-Add-blk_rq_map_kern_sg.patch
0002-SCSI-scst-Add-SCST-core.patch
0003-SCSI-scst-Add-scst_local-driver.patch
0004-SCSI-scst-Add-SRP-target-driver.patch
0005-SCSI-ibmvstgt-Port-from-tgt-to-SCST.patch
0006-SCSI-tgt-Removal.patch
0007-SCSI-tgt-Defconfig-cleanup.patch

The most important changes since the previous time SCST was posted as a
patch set (http://lkml.org/lkml/2010/10/1/140) are:
- Rewrote the SCST sysfs interface such that it uses the bus/driver/device
  infrastructure instead of creating kernel objects in /sys/kernel/scst_tgt.
- Completed porting of the ibmvstgt driver.

This patch set is also available in the scst branch of this git repository:

git://git.kernel.org/pub/scm/linux/kernel/git/bvanassche/scst.git

or alternatively, via the kernel.org git web interface on the same repository:

http://git.kernel.org/?p=linux/kernel/git/bvanassche/scst.git;a=shortlog;h=refs/heads/scst
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
