From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] 2.6.2-rc2 - MPT Fusion driver 3.00.02 update
Date: Mon, 26 Jan 2004 12:01:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703D19D33@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:55250 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S264285AbUAZRBy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2004 12:01:54 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@infradead.org

I will work on that.  

I had avoided it due the comments in the code
from sralston and pdelaney about sg interface 
gererating wrong direction in some cases.  

Eric


On Monday, January 26, 2004 9:45 AM, James Bottomley wrote:
> On Mon, 2004-01-26 at 10:37, Moore, Eric Dean wrote:
> > Here is another update for the MPT Fusion drivers.
> 
> Thanks.
> 
> > * added CONFIG_LBA, READ16, WRITE16 support
> 
> I'd like to see this routine to determine direction go away 
> in favour of
> just using the direction the mid layer sends down.  However, 
> this isn't
> a blocking item, I'll try and get this update into early 2.6.2
> 
> James
> 
> 
