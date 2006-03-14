From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH ] drivers/base/bus.c - export reprobe
Date: Tue, 14 Mar 2006 17:08:55 +0000
Message-ID: <20060314170855.GA18342@infradead.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F36D829@NAMAIL2.ad.lsil.com> <20060314153455.GA8071@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750943AbWCNRJA@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060314153455.GA8071@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 14, 2006 at 07:34:55AM -0800, Greg KH wrote:
> Also, it looks like USB needs to call this function, (based on the
> comment)?  Care to switch that code over to have it use it too?

what comment do you think indicates that?  It's needed for raid drivers
that

  a) expose physical volumes but set the no_uld_attach flag to hide them
     from sd
  b) allow only raid volume creation/deletion so this flag may be set/cleared
     at runtime
