From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged
Date: Sun, 5 Sep 2004 00:26:14 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0409050022570.3092@poirot.grange>
References: <Pine.LNX.4.60.0409040033310.5266@poirot.grange>
 <20040904140102.A15247@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:52953 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263806AbUIDW0v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Sep 2004 18:26:51 -0400
In-Reply-To: <20040904140102.A15247@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Sat, 4 Sep 2004, Christoph Hellwig wrote:

> On Sat, Sep 04, 2004 at 12:41:00AM +0200, Guennadi Liakhovetski wrote:
>> Hello
>>
>> The attached patch makes sure, all INQUIRY commands are only sent
>> untagged. This way drives, affected by bug 2139, also survive further
>> INQUIRYs, sent after the initial scan, e.g., by scsiinfo.
>
> Looks basically good to me, but if you want to store SCSI_NO_TAG in
> ->TagNumber I'd suggest that you make it an unsigned type.

It is unsigned (u8) now. Or did you mean signed, since SCSI_NO_TAG is 
defined as (-1). I thought about making TagNumber an int, but I didn't 
bother, because it is anyway due removal...

Thanks
Guennadi
---
Guennadi Liakhovetski

