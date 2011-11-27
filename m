From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: (repost) vhost tree for linux-next
Date: Sun, 27 Nov 2011 14:48:17 +0200
Message-ID: <20111127124816.GA23270@redhat.com>
References: <20111124203843.GC4873@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956Ab1K0Mqn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Nov 2011 07:46:43 -0500
Content-Disposition: inline
In-Reply-To: <20111124203843.GC4873@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-next@vger.kernel.org
Cc: sfr@canb.auug.org.au, linux-pci@vger.kernel.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org

I normally merge things through Dave, Rusty, Jesse or Jens,
not directly to Linus. However, sometimes there's a large change
(for example, my recent RFC for pci_iomap changes)
where estimating how it interacts with other platforms and planned
changes in the next kernel would be beneficial.

For this purpose, it would be helpful if my tree were added to linux-next.
The tree is:
git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next

Could you do this please?
(The current contents of that tree was posted for review/feedback
for the first time today.   It might make sense to give it a few days
for any responses ...)

Thanks!

-- 
MST
