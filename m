From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 19 Aug 2005 16:06:31 +0200
Message-ID: <20050819140631.GB12485@lst.de>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com> <4304DBA1.4050900@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:48088 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964815AbVHSOGx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 10:06:53 -0400
Content-Disposition: inline
In-Reply-To: <4304DBA1.4050900@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James.Smart@Emulex.Com, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On Thu, Aug 18, 2005 at 03:04:01PM -0400, Jeff Garzik wrote:
> >Depending on how SATA support is implemented, it may be useful for that.
> 
> 
> You can already see how SATA support is implemented ;-)
> 
> We just need to wrap it in a transport class.

SATA support for SAS host adapters.  Especially when talking STP to a
bridge this is a little more complicated than the current libata model.
That doesn't mean I don't want to share code and mechanisms but it'll
need a little refactoring at least.
