From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric
	module
Date: Sat, 19 Mar 2011 12:25:46 -0700
Message-ID: <1300562746.15328.13.camel@haakon2.linux-iscsi.org>
References: <1300487957-28800-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300487957-28800-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-03-18 at 15:39 -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds the TCM_Loop Linux/SCSI LLD fabric module for accessing TCM device
> backstores as locally accessable SCSI LUNs in virtual SAS, FC, and iSCSI Target ports
> using the generic fabric TransportID and Target Port WWN naming handlers from TCM's
> target_core_fabric_lib.c  The TCM_Loop module uses the generic fabric configfs infratructure
> provided by target_core_fabric_configfs.c and adds a module dependent attribute for the
> creation/release of the virtual I_T Nexus connected the TCM_Loop Target and Initiator Ports.
> 
> TCM_Loop can also be used with scsi-generic and BSG drivers so that STGT userspace
> fabric modules, QEMU-KVM and other hypervisor SCSI passthrough support can
> access TCM device backstore and control CDB emulation.
> 
> For more information please see:
> 
> http://linux-iscsi.org/wiki/Tcm_loop
> 
> This patch has been updated with changes from Christoph's feedback.
> 
> Changed from v1 -> v2:
> 
> Remove dead extern prototypes and make all functions statically defined.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Hi James,

Thanks for merging the for-39 target core fixes.  At this point the
TCM_Loop PATCH-v2 is ready to be merged into scsi-misc as well.  Please
review and let me know if you have any questions or comments.

Thank you,

--nab
