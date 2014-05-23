From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] virtio-scsi: replace target spinlock with seqcount
Date: Fri, 23 May 2014 15:59:52 +0200
Message-ID: <537F5458.6010008@redhat.com>
References: <1400851712-26731-1-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbaEWOAS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2014 10:00:18 -0400
In-Reply-To: <1400851712-26731-1-git-send-email-ming.lei@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Rusty Russell <rusty@rustcorp.com.au>

Il 23/05/2014 15:28, Ming Lei ha scritto:
> The spinlock of tgt_lock is only for serializing read and write
> req_vq, one lockless seqcount is enough for the purpose.
>
> On one 16core VM with vhost-scsi backend, the patch can improve
> IOPS with 3% on random read test.

Nice. :)  The patch looks good, thanks for working this out!

James, I have a couple more patches planned for virtio-scsi, so I'll 
send out the update next week.

Paolo
