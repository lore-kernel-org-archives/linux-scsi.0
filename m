From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] uas: Make uas work with blk-mq
Date: Thu, 2 Oct 2014 04:26:27 -0700
Message-ID: <20141002112627.GC17628@infradead.org>
References: <1412244280-15111-1-git-send-email-hdegoede@redhat.com>
 <1412244280-15111-2-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33854 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaJBL03 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 07:26:29 -0400
Content-Disposition: inline
In-Reply-To: <1412244280-15111-2-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@infradead.org>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Looks fine to me (and actually removes code..)

Reviewed-by: Christoph Hellwig <hch@lst.de>

It's fairly late in 3.17 to get something like this in, but would you
consider Ccing it to stable so we can get it into the first 3.17 stable
release?
