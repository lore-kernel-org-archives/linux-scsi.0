From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] [USB] UAS: Use kzalloc instead of kmalloc
Date: Mon, 8 Nov 2010 07:55:13 -0800
Message-ID: <20101108155513.GC10092@kroah.com>
References: <628096.54960.qm@web31807.mail.mud.yahoo.com>
 <20101108112131.GG4173@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:54793 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab0KHQAF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Nov 2010 11:00:05 -0500
Content-Disposition: inline
In-Reply-To: <20101108112131.GG4173@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Nov 08, 2010 at 06:21:31AM -0500, Matthew Wilcox wrote:
> On Wed, Oct 27, 2010 at 01:22:22PM -0700, Luben Tuikov wrote:
> > "Be conservative in what you send, liberal in what
> > you accept." -- In the spirit of this adage, don't
> > send Command IUs with randomly filled in data in
> > the reserved fields. (Yes, this shows up on the
> > wire.)
> 
> Applied, with a better changelog entry ...

Applied to where?  Shouldn't these patches go into my tree that feeds
into linux-next?

We really don't want driver-specific trees floating around anywhere,
please push them to me if possible.

thanks,

greg k-h
