From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/6] target: Convert REPORT_LUNs to use int_to_scsilun
Date: Tue, 24 May 2011 17:52:12 -0700
Message-ID: <1306284732.29724.167.camel@haakon2.linux-iscsi.org>
References: <1305861554-29960-1-git-send-email-nab@linux-iscsi.org>
	 <1305861554-29960-6-git-send-email-nab@linux-iscsi.org>
	 <1306256577.10201.13.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45136 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab1EYBAa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2011 21:00:30 -0400
In-Reply-To: <1306256577.10201.13.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>

On Tue, 2011-05-24 at 13:02 -0400, James Bottomley wrote:
> On Thu, 2011-05-19 at 20:19 -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch converts transport_core_report_lun_response() to use
> > drivers/scsi/scsi_scan.c:int_to_scsilun instead of using the
> > struct target_core_fabric_ops->pack_lun() fabric provided API vector.
> > 
> > It also removes the tfo->pack_lun check from target_fabric_tf_ops_check()
> > and removes from struct target_core_fabric_ops->pack_lun() from
> > target_core_fabric_ops.h, and the following mainline scsi-misc fabric
> > modules:
> > 
> > *) tcm_loop: Drop tcm_loop_pack_lun() usage
> > *) tcm_fc: Drop ft_pack_lun() usage
> > 
> > Reported-by: Mike Christie <michaelc@cs.wisc.edu>
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> 
> There's no way this or the following patch count as bug fixes.  They're
> converging hand rolled functions and definitions (which is good, but not
> a bug fix).
> 

Correct, patches # 1 -> 4 where the bugfixes patches of this series that
needed to go to also go into stable, but the remaining two patches
requested by Mike and Christoph during iscsi-target review are >= .40
only material.

Thank you!

--nab


