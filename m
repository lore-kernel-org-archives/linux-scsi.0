From: Jens Axboe <axboe@suse.de>
Subject: Re: [linux-usb-devel] Re: Unaligned scatter-gather buffers and usb-storage
Date: Wed, 19 Nov 2003 14:04:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031119130400.GG1106@suse.de>
References: <20031110095914.B22518@beaverton.ibm.com> <20031118143720.A6411@beaverton.ibm.com> <20031119084729.GA1106@suse.de> <200311191401.34540.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:57729 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264063AbTKSNEM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 08:04:12 -0500
Content-Disposition: inline
In-Reply-To: <200311191401.34540.oliver@neukum.org>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Wed, Nov 19 2003, Oliver Neukum wrote:
> 
> > > You could add a scsi_host fields or bits specifying alignment
> > > restrictions, and enforce them as needed in upper level drivers.
> > 
> > The queue already has such a restriction embedded, see bio_map_user()
> > and queue_dma_alignment().
> 
> Very well, as far as sd and sr are concerned, but it doesn't help for
> sg and st, does it?

They both have a queue through the scsi device structure. But you could
put the value someplace else if you wanted.

-- 
Jens Axboe

