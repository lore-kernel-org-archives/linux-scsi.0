From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 19 Aug 2005 13:51:56 -0400
Message-ID: <43061C3C.2020303@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com> <4304DBA1.4050900@pobox.com> <20050819140631.GB12485@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:16295 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S964994AbVHSRwD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 13:52:03 -0400
In-Reply-To: <20050819140631.GB12485@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, James.Smart@Emulex.Com, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On 08/19/05 10:06, Christoph Hellwig wrote:
> SATA support for SAS host adapters.  Especially when talking STP to a
> bridge this is a little more complicated than the current libata model.
> That doesn't mean I don't want to share code and mechanisms but it'll
> need a little refactoring at least.

I'm not understanding what you mean here.

If the lower level is implemented correctly, libata would
just pick up and "drive" the ATA device.

	Luben
