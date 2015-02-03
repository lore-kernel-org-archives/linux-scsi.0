From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH-v3 5/9] vhost/scsi: Add ANY_LAYOUT vhost_virtqueue
 callback
Date: Tue, 3 Feb 2015 16:22:20 +0100
Message-ID: <20150203152220.GA9063@redhat.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
 <1422945003-24538-6-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933996AbbBCPWc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Feb 2015 10:22:32 -0500
Content-Disposition: inline
In-Reply-To: <1422945003-24538-6-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>

> +		 * copy_from_iter() is modifying the iovecs as copies over
> +		 * req_size bytes into req, so the returned out_iter.iov[0]
> +		 * will contain the correct start + offset of the outgoing
> +		 * WRITE payload, if DMA_TO_DEVICE is set.
> +		 */

Does it, in fact, do this?
I thought so too, but Al Viro corrected me that it's
not supposed to.

-- 
MST
