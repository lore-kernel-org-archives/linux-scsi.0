From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
Date: Mon, 28 Mar 2005 09:34:30 -0300
Message-ID: <20050328123430.GC29310@logos.cnet>
References: <20050328103324.GB28175@logos.cnet> <1112024363.5531.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([209.128.68.125]:1205 "EHLO hera.kernel.org")
	by vger.kernel.org with ESMTP id S261963AbVC1RZO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 12:25:14 -0500
Content-Disposition: inline
In-Reply-To: <1112024363.5531.5.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Mar 28, 2005 at 09:39:23AM -0600, James Bottomley wrote:
> On Mon, 2005-03-28 at 07:33 -0300, Marcelo Tosatti wrote:
> > You probably already know about this, but just in case:
> > 
> > v2.6.12-rc1 yields
> > 
> > program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
> 
> Actually, a lot of programs do this.  Since about 2.6.11 (I think, might
> be earlier), the SCSI subsystem has actually begun warning about the use
> of ioctls which have been deprecated for a while.
> 
> The solution is to fix up the scsi_unique_id program to use SG_IO.

Doh. 

I'm using FC2 - FC3 probably has it updated.

Sorry for the noise.
