From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH ] drivers/scsi/scsi.c - export reprobe
Date: Tue, 14 Mar 2006 16:08:28 +0000
Message-ID: <20060314160828.GA18239@infradead.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F36D82A@NAMAIL2.ad.lsil.com> <20060314153524.GB8071@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49557 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751026AbWCNQIe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Mar 2006 11:08:34 -0500
Content-Disposition: inline
In-Reply-To: <20060314153524.GB8071@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, hch@lst.de

On Tue, Mar 14, 2006 at 07:35:24AM -0800, Greg KH wrote:
> On Mon, Mar 13, 2006 at 05:52:43PM -0700, Moore, Eric wrote:
> > Request for exporting device_reprobe - 
> > This is scsi wrapper portion.
> 
> Is this even really needed?  It's just a single pointer dereference...

We don't want SCSI LLDDs to know about implementations details like
sdev->sdev_gendev.  Of course an inline or a macro could do this aswell.

