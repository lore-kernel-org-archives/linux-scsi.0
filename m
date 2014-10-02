From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] uas: Make uas work with blk-mq
Date: Thu, 2 Oct 2014 06:12:59 -0700
Message-ID: <20141002131259.GA930@infradead.org>
References: <1412244280-15111-1-git-send-email-hdegoede@redhat.com>
 <1412244280-15111-2-git-send-email-hdegoede@redhat.com>
 <20141002112627.GC17628@infradead.org>
 <542D467E.2020400@redhat.com>
 <20141002130654.GA17051@infradead.org>
 <542D4E58.5000809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45629 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbaJBNNC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 09:13:02 -0400
Content-Disposition: inline
In-Reply-To: <542D4E58.5000809@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Oct 02, 2014 at 03:08:40PM +0200, Hans de Goede wrote:
> Yes, although that likely would need to go through stable, without
> going into 3.18 .
> 
> Greg, is this ok with you and how do I get a patch in stable which
> is not in upstream (because upstream will get a better fix) ?

This is a trivial one liner and 3.17 isn't released yet, so can you just
send it to Linus now?

