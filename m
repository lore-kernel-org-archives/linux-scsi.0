From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 19 Aug 2005 19:54:59 +0200
Message-ID: <20050819175459.GA16619@lst.de>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com> <4304DBA1.4050900@pobox.com> <20050819140631.GB12485@lst.de> <43061C3C.2020303@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:9182 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S965006AbVHSRzW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 13:55:22 -0400
Content-Disposition: inline
In-Reply-To: <43061C3C.2020303@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James.Smart@Emulex.Com, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On Fri, Aug 19, 2005 at 01:51:56PM -0400, Luben Tuikov wrote:
> On 08/19/05 10:06, Christoph Hellwig wrote:
> > SATA support for SAS host adapters.  Especially when talking STP to a
> > bridge this is a little more complicated than the current libata model.
> > That doesn't mean I don't want to share code and mechanisms but it'll
> > need a little refactoring at least.
> 
> I'm not understanding what you mean here.
> 
> If the lower level is implemented correctly, libata would
> just pick up and "drive" the ATA device.

Yes.  But to get that to work we'll need to fix some assumptions in
libata, define proper interfaces between the SAS LLDD, the SAS transport
class and libata.  It's doable and desirable, but it'll need some work.

