From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH ] drivers/scsi/scsi.c - export reprobe
Date: Tue, 14 Mar 2006 17:31:41 +0100
Message-ID: <1142353902.3027.39.camel@laptopd505.fenrus.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F36D82A@NAMAIL2.ad.lsil.com>
	 <20060314153524.GB8071@suse.de>  <20060314160828.GA18239@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:25069 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751338AbWCNQbs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Mar 2006 11:31:48 -0500
In-Reply-To: <20060314160828.GA18239@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Greg KH <gregkh@suse.de>, "Moore, Eric" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, hch@lst.de

On Tue, 2006-03-14 at 16:08 +0000, Christoph Hellwig wrote:
> On Tue, Mar 14, 2006 at 07:35:24AM -0800, Greg KH wrote:
> > On Mon, Mar 13, 2006 at 05:52:43PM -0700, Moore, Eric wrote:
> > > Request for exporting device_reprobe - 
> > > This is scsi wrapper portion.
> > 
> > Is this even really needed?  It's just a single pointer dereference...
> 
> We don't want SCSI LLDDs to know about implementations details like
> sdev->sdev_gendev.  Of course an inline or a macro could do this aswell.


this looks like a good candidate for an inline yes ;)

