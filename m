From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] add SPI transport class to fusion
Date: Tue, 31 Jan 2006 09:04:49 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F2214BF@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:7159 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751041AbWAaQFU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 11:05:20 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@lst.de

I wrote: 

> > Yes ... it's the job of whoever is issuing passthrough I/O 
> to ensure the
> > RAID is quiesced (if they need it ... there are plenty of 
> commands that
> > could be usefully executed even with the RAID running), so 
> really, we
> > only need it for the DV because additional I/O could interfere with
> > that.
> > 

James:  I asked around about my quiesce-io concern this morning.  This 
particular concern can be dropped.   They agree with your
implementation,
whereas we only do this from dv.   Thanks...

Eric Moore
