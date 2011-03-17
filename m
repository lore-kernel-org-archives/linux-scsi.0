From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] First round of SCSI updates for 2.6.38 merge window
Date: Thu, 17 Mar 2011 14:19:09 -0700
Message-ID: <1300396749.28255.554.camel@haakon2.linux-iscsi.org>
References: <1300392635.17266.5.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53210 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab1CQV0N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2011 17:26:13 -0400
In-Reply-To: <1300392635.17266.5.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, 2011-03-17 at 16:10 -0400, James Bottomley wrote:
> This represents the usual round of driver updates (fcoe, lpfc, qla2xxx,
> zfcp, bnx2i, mpt2sas, megaraid_sas, iscsi, cxgbi and hpsa) plus one new
> driver (bnx2fc) and as a bonus we move libsas from the old libata eh to
> the new one paving the way for junking the old one (once we can get ipr
> converted).
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> 

<SNIP>

> 
> Nicholas Bellinger (1):
>       target: Fix volume size misreporting for volumes > 2TB

James,

Just as a heads up I have pushed the deferred 'for-38' target core fixes
you requested previously and the new 'for-39' target_core_stat.c
configfs statistics group code, which was posted to linux-scsi here:

[PATCH 00/21] target patches for .39 scsi-misc (v3)

http://marc.info/?l=linux-scsi&m=130010108521141&w=2

into a branch available here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-39-misc-v4

Please make sure these are picked up for target core going to mainline
ASAP.

The RFC-v3 for iscsi_target_mod will be going out shortly.

Thanks,

--nab

