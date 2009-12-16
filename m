From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] final set of SCSI updates for the merge window
Date: Wed, 16 Dec 2009 15:16:22 -0800
Message-ID: <20091216151622.f74b2b97.akpm@linux-foundation.org>
References: <1261003896.14435.157.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935275AbZLPXQ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 18:16:26 -0500
In-Reply-To: <1261003896.14435.157.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
drivers-scsi-libsas-use-sam_good.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
mpt-fusion-convert-to-seq_file.patch
scsi-aacraid-fix-memory-leak.patch
scsi-aacraid-fix-memory-leak-checkpatch-fixes.patch
scsi-remove-unnecessary-null-test.patch
scsi-lpfc-fix-memory-leak.patch

I've been sitting on some of these since June.

This is just broken.  How do I fix it?
