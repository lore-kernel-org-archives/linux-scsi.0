From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC] libata new EH document
Date: Thu, 01 Sep 2005 18:09:15 -0400
Message-ID: <43177C0B.9040500@adaptec.com>
References: <20050901043850.15186.qmail@web51611.mail.yahoo.com>	 <43169520.6040008@gmail.com>  <20050901055421.GA23496@havoc.gtf.org> <1125581097.4834.5.camel@mulgrave> <4317755C.5080700@adaptec.com> <431776A0.2030107@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:57999 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1030440AbVIAWJY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2005 18:09:24 -0400
In-Reply-To: <431776A0.2030107@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Tejun Heo <htejun@gmail.com>, ltuikov@yahoo.com, Albert Lee <albertcc@tw.ibm.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Doug Maxey <dwm@maxeymade.com>

On 09/01/05 17:46, Jeff Garzik wrote:
>>>>libata is simply being lazy:  while the SCSI core continues to support
>>>>kicking the EH thread when sense is missing, it's preferred for libata
>>>>to reuse that infrastructure.
>>>
>>>
>>>That makes the most sense ;-)
>>
>>
>>For libata it doesn't really matter, since it is _ATA_.
> 
> It matters quite a bit.  One of the main reasons libata uses the SCSI 
> layer is for its infrastructure.

Hmm, maybe I should've been more clear.

> This is the same reason a couple RAID drivers use the SCSI layer.  It 
> has nothing to do with SCSI-as-defined-by-T10, and more to do with the 
> fact that SCSI provides a robust queueing/EH/block interface infrastructure.

You must be kidding! "robust"?  What are you comparing this to?

I think it's only because "it's there" and that it provides
a uniform access -- provided by SCSI, _not_ by that particular
SCSI implementation.

> My long term plans include moving some of this not-SCSI-related 
> infrastructure from the SCSI layer to the block layer.

Which is that infrastructure?

	Luben

