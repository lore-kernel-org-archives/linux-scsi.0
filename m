From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target: Updates for v3.2-rc1 (round two)
Date: Sun, 06 Nov 2011 22:47:54 -0800
Message-ID: <1320648474.28530.18.camel@haakon2.linux-iscsi.org>
References: <1320437345.5859.94.camel@haakon2.linux-iscsi.org>
	 <1320634778.18988.10.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60417 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1KGGsV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2011 01:48:21 -0500
In-Reply-To: <1320634778.18988.10.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, Bart Van Assche <bvanassche@acm.org>

On Sun, 2011-11-06 at 18:59 -0800, Nicholas A. Bellinger wrote:
> Hi Linus,
> 
> This is just a friendly reminder to please pull the two remaining
> target-pending branches (for-next and for-next-merge) for -rc1.
> 

Thanks for pulling the target core changes from target-pending/for-next.

Please also consider pulling the new ib_srpt driver in for-next-merge
here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next-merge

We are making forward progress on the remaining items to be included in
the next rc-fixes pull, but please consider the last GIT PULL request
below for an initial merge with what we have collectively agreed upon
for the userspace API in /sys/kernel/config/target/srpt for v3.2.

[GIT PULL] ib_srpt: Initial SRP Target merge for v3.2-rc1
http://marc.info/?l=linux-rdma&m=132043748907782&w=2

Thank you,

--nab



