From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL-v2] iscsi-target merge for v3.1-rc1
Date: Wed, 27 Jul 2011 15:48:31 -0700
Message-ID: <1311806911.6931.65.camel@haakon2.linux-iscsi.org>
References: <1311732839.10646.132.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45747 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab1G0W5x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2011 18:57:53 -0400
In-Reply-To: <1311732839.10646.132.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <openosd@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>, Dan Carpenter <error27@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>

On Tue, 2011-07-26 at 19:13 -0700, Nicholas A. Bellinger wrote:
> Hi Linus,
> 
> Here is an updated pull request for an initial v3.1-rc1 merge of
> iscsi_target including the updates to address some recent build breakage
> with iscsi_proto.h in linux-next, and minor build warnings on 32-bit.
> 
> This also includes the DIV_ROUND_UP_SECTOR_T bit and associated change
> for targte_core_mod from this morning that address the 32-bit unsigned
> long long division build issues as per your direction on LKML.  This can
> definately use some more discussion and testing in linux-next, so please
> let me know if how you prefer to merge these.
> 
> The series is available directly here:
> 
>   master.kernel.org:/pub/scm/linux/kernel/git/nab/target-pending.git for-next
> 
> This tree is also available from kernel.org mirrors at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next
> 
> The series is based on the following mainline HEAD:
> 
> commit bbd9d6f7fbb0305c9a592bf05a32e87eb364a4ff
> Merge: 8e20487 5a9a436
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Fri Jul 22 19:02:39 2011 -0700
> 
>     Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6
> 
> Also just double checking, here the for-next branch is merge conflict
> free on yesterdays linux-next (20110725), and latest mainline HEAD from
> afternoon.
> 
> Thank you,
> 

Hi Linus,

Thank you for pulling in iscsi-target for an initial v3.1 merge!

The for-next branch has been updated to address this morning's reported
items with Dan's fixes and Randy's CONFIG_SMP=n + CONFIG_MODULES=n build
breakage.

I'll keep queueing up v3.1-rc1 bugfixes in for-next and will follow up
with a fixes-only pull request early next week, unless of course you
want it earlier than that.  :)

Thanks again, and please let us know if you have any concerns,

--nab

