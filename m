From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH ] drivers/base/bus.c - export reprobe
Date: Tue, 14 Mar 2006 17:25:43 +0000
Message-ID: <20060314172543.GA20331@infradead.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F36D829@NAMAIL2.ad.lsil.com> <20060314153455.GA8071@suse.de> <20060314170855.GA18342@infradead.org> <20060314171951.GA22678@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:10413 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751386AbWCNRZq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Mar 2006 12:25:46 -0500
Content-Disposition: inline
In-Reply-To: <20060314171951.GA22678@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, "Moore, Eric" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, hch@lst.de

On Tue, Mar 14, 2006 at 09:19:51AM -0800, Greg KH wrote:
> I saw the:
> 
> +       if (dev->driver) {^M
> +               if (dev->parent)        /* Needed for USB */^M
> +                       down(&dev->parent->sem);^M
> 
> portion and thought it came from USB core code somewhere.  Or are you
> referring to the need for USB-storage here?

It's copied from a runtime close to this one in the driver core.
Unfortunately it's not easily sharable so I duplicated those few lines.

