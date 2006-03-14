From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH ] drivers/base/bus.c - export reprobe
Date: Tue, 14 Mar 2006 07:34:55 -0800
Message-ID: <20060314153455.GA8071@suse.de>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F36D829@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:47547 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S1750726AbWCNPgV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Mar 2006 10:36:21 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F36D829@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, hch@lst.de

On Mon, Mar 13, 2006 at 05:52:40PM -0700, Moore, Eric wrote:
> Request for exporting device_reprobe - 
> 
> Adding support for exposing hidden raid components 
> for sg interface. The sdev->no_uld_attach flag
> will set set accordingly.
> 
> The sas module supports adding/removing raid
> volumes using online storage management application
> interface.  
> 
> This patch was provided to me by Christoph Hellwig.
> 
> Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

base64 for the attachment with DOS line ends?  ugh, can you please fix
this up and resend?

Also, it looks like USB needs to call this function, (based on the
comment)?  Care to switch that code over to have it use it too?

thanks,

greg k-h
