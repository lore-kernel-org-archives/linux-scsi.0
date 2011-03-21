From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric
	module
Date: Mon, 21 Mar 2011 12:14:54 -0700
Message-ID: <1300734894.16275.0.camel@haakon2.linux-iscsi.org>
References: <1300487957-28800-1-git-send-email-nab@linux-iscsi.org>
	 <1300721399.10634.9.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43869 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab1CUTWQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2011 15:22:16 -0400
In-Reply-To: <1300721399.10634.9.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Douglas Gilbert <dgilbert@interlog.com>

On Mon, 2011-03-21 at 10:29 -0500, James Bottomley wrote:
> On Fri, 2011-03-18 at 15:39 -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds the TCM_Loop Linux/SCSI LLD fabric module for accessing TCM device
> > backstores as locally accessable SCSI LUNs in virtual SAS, FC, and iSCSI Target ports
> > using the generic fabric TransportID and Target Port WWN naming handlers from TCM's
> > target_core_fabric_lib.c  The TCM_Loop module uses the generic fabric configfs infratructure
> > provided by target_core_fabric_configfs.c and adds a module dependent attribute for the
> > creation/release of the virtual I_T Nexus connected the TCM_Loop Target and Initiator Ports.
> > 
> > TCM_Loop can also be used with scsi-generic and BSG drivers so that STGT userspace
> > fabric modules, QEMU-KVM and other hypervisor SCSI passthrough support can
> > access TCM device backstore and control CDB emulation.
> > 
> > For more information please see:
> > 
> > http://linux-iscsi.org/wiki/Tcm_loop
> > 
> > This patch has been updated with changes from Christoph's feedback.
> > 
> > Changed from v1 -> v2:
> > 
> > Remove dead extern prototypes and make all functions statically defined.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> This is a major No-no: you can't actually add a reviewed by tag until
> the actual reviewer says so (and Christoph hasn't said so anywhere).
> Even if he had, and you think you've responded to all Christophs
> concerns, you still need to wait for him to look at the file and agree.
> 

Fair enough.  Chrisopth, are you happy with the code at this point..?

Thanks,

--nab

