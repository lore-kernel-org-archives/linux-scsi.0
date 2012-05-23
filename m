From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: linux-next: Tree for May 23
Date: Wed, 23 May 2012 01:10:57 -0700
Message-ID: <1337760657.22481.256.camel@haakon2.linux-iscsi.org>
References: <20120523170740.ae058d8d5468d471eb948c39@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37207 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab2EWILD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2012 04:11:03 -0400
In-Reply-To: <20120523170740.ae058d8d5468d471eb948c39@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2012-05-23 at 17:07 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20120522:
> 
> New tree: signal
> 
> With the merge window open, conflicts are moving from tree to tree.
> 

...

> 
> $ git checkout master
> $ git reset --hard stable
> Merging origin/master (fb09baf Merge tag 'staging-3.5-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging)

<SNIP>

> Merging scsi/for-next (841f97b [SCSI] qla2xxx: don't free pool that wasn't allocated)
> Merging target-updates/for-next (f80e8ed iscsi-target: Fix iov_count calculation bug in iscsit_allocate_iovecs)
> Merging target-merge/for-next-merge (ef872d2 Merge branch 'qla-target-merge' into for-next-merge)
> CONFLICT (add/add): Merge conflict in drivers/scsi/qla2xxx/tcm_qla2xxx.c
> CONFLICT (add/add): Merge conflict in drivers/scsi/qla2xxx/qla_target.h
> CONFLICT (add/add): Merge conflict in drivers/scsi/qla2xxx/qla_target.c
> CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_os.c
> CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_mbx.c
> CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_def.h
> CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_dbg.h

Just wanted to mention that qla-target-merge branch has been dropped
from target-merge/for-next-merge now that these patches have hit James'
scsi/for-next tree.

Thank you Stephen!

--nab





