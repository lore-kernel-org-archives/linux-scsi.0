From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] Re: Unaligned scatter-gather buffers and usb-storage
Date: Wed, 19 Nov 2003 14:01:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200311191401.34540.oliver@neukum.org>
References: <20031110095914.B22518@beaverton.ibm.com> <20031118143720.A6411@beaverton.ibm.com> <20031119084729.GA1106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.kontent.de ([81.88.34.36]:1480 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S264038AbTKSNCN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 08:02:13 -0500
In-Reply-To: <20031119084729.GA1106@suse.de>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, Patrick Mansfield <patmans@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>


> > You could add a scsi_host fields or bits specifying alignment
> > restrictions, and enforce them as needed in upper level drivers.
> 
> The queue already has such a restriction embedded, see bio_map_user()
> and queue_dma_alignment().

Very well, as far as sd and sr are concerned, but it doesn't help for
sg and st, does it?

	Regards
		Oliver

