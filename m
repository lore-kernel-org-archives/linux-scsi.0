From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: regression fix
Date: Fri, 17 Jun 2005 08:15:24 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B01520956@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:4825 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261442AbVFQMQL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2005 08:16:11 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

But then we are requested to byteswap the 1's constant ... ;-}

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Friday, June 17, 2005 7:21 AM
To: Mark Haverkamp
Cc: James Bottomley; Salyzyn, Mark; linux-scsi
Subject: Re: [PATCH] aacraid: regression fix

On Wed, Jun 15, 2005 at 09:36:46AM -0700, Mark Haverkamp wrote:
> -		kfib->header.XferState = 0;
> +		kfib->header.XferState = cpu_to_le32(0);

you never need to byte-swap the 0 constant.

