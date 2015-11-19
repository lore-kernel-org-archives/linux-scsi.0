From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RESEND_2] scsi_sysfs: protect against double execution of
 __scsi_remove_device()
Date: Thu, 19 Nov 2015 05:40:37 -0800
Message-ID: <20151119134037.GA12247@infradead.org>
References: <1447938139-22072-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbbKSNkj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2015 08:40:39 -0500
Content-Disposition: inline
In-Reply-To: <1447938139-22072-1-git-send-email-vkuznets@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, Bart Van Assche <bart.vanassche@sandisk.com>

This looks fine to me.  I wonder why we even bother returning
deleted devices for a normal scsi_device_lookup, but let's get
this isolated fix in for now and sort out the big picture later.

Reviewed-by: Christoph Hellwig <hch@lst.de>
