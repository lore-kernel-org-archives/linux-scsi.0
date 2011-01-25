From: Madhu Iyengar <madhu.iyengar@qlogic.com>
Subject: RE: [PATCHSET] workqueue: update workqueue users - replace
 create_workqueue()
Date: Tue, 25 Jan 2011 09:47:16 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87225EF7CBE@AVEXMB1.qlogic.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <20110125142921.GB27510@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:29989 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1AYRrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jan 2011 12:47:21 -0500
In-Reply-To: <20110125142921.GB27510@htj.dyndns.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Madhu Iyengar <madhu.iyengar@qlogic.com>

Tejun,

Here's my ack for patch #16 from the QLogic side:

Acked-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

Cheers,
Madhu

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Tejun Heo
Sent: Tuesday, January 25, 2011 6:29 AM
To: linux-kernel@vger.kernel.org
Cc: lenb@kernel.org; linux-acpi@vger.kernel.org; davej@redhat.com; cpufreq@vger.kernel.org; Markus.Lidel@shadowconnect.com; tomas.winkler@intel.com; jayamohank@serverengines.com; Andrew Vasquez; James.Bottomley@HansenPartnership.com; linux-scsi@vger.kernel.org; tomof@acm.org; stf_xl@wp.pl; linux-usb@vger.kernel.org; tytso@mit.edu; mfasheh@suse.com; joel.becker@oracle.com; reiserfs-devel@vger.kernel.org; aelder@sgi.com; hch@infradead.org; ericvh@gmail.com; rminnich@sandia.gov; v9fs-developer@lists.sourceforge.net; lucho@ionkov.net; andy.grover@oracle.com
Subject: Re: [PATCHSET] workqueue: update workqueue users - replace create_workqueue()

Hello,

There was no response for the following patches and I'm planning on
routing them through workqueue#for-2.6.39.  If you have an objection
or want to take the patch through a different tree, please let me
know.

 0006-acpi-kacpi-_wq-don-t-need-WQ_MEM_RECLAIM.patch
 0007-cpufreq-use-system_wq-instead-of-dedicated-workqueue.patch
 0012-i2o-use-alloc_workqueue-instead-of-create_workqueue.patch
 0013-misc-iwmc3200top-use-system_wq-instead-of-dedicated-.patch
 0016-scsi-be2iscsi-qla2xxx-convert-to-alloc_workqueue.patch
 0018-scsi-scsi_tgt_lib-scsi_tgtd-isn-t-used-in-memory-rec.patch
 0019-usb-ueagle-atm-use-system_wq-instead-of-dedicated-wo.patch
 0025-ext4-convert-to-alloc_workqueue.patch
 0026-ocfs2-use-system_wq-instead-of-ocfs2_quota_wq.patch
 0027-reiserfs-make-commit_wq-use-the-default-concurrency-.patch
 0028-xfs-convert-to-alloc_workqueue.patch
 0029-net-9p-use-system_wq-instead-of-p9_mux_wq.patch
 0030-net-9p-replace-p9_poll_task-with-a-work.patch
 0031-rds-ib-use-system_wq-instead-of-rds_ib_fmr_wq.patch

The whole series can be found at the following URL.

 http://thread.gmane.org/gmane.linux.kernel/1082587

Thank you.

--
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
