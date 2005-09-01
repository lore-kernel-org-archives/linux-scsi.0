From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] libata new EH document
Date: Thu, 01 Sep 2005 17:46:08 -0400
Message-ID: <431776A0.2030107@pobox.com>
References: <20050901043850.15186.qmail@web51611.mail.yahoo.com>	 <43169520.6040008@gmail.com>  <20050901055421.GA23496@havoc.gtf.org> <1125581097.4834.5.camel@mulgrave> <4317755C.5080700@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4317755C.5080700@adaptec.com>
Sender: linux-ide-owner@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Tejun Heo <htejun@gmail.com>, ltuikov@yahoo.com, Albert Lee <albertcc@tw.ibm.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Doug Maxey <dwm@maxeymade.com>
List-Id: linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> On 09/01/05 09:24, James Bottomley wrote:
> 
>>On Thu, 2005-09-01 at 01:54 -0400, Jeff Garzik wrote:
>>
>>
>>>The long term direction for the SCSI core seems to be that of
>>>requiring auto-sensing.
>>
>>
>>No, I don't see the mid-layer error thread handling of this ever going
>>away.
>>
>>
>>>libata is simply being lazy:  while the SCSI core continues to support
>>>kicking the EH thread when sense is missing, it's preferred for libata
>>>to reuse that infrastructure.
>>
>>
>>That makes the most sense ;-)
> 
> 
> For libata it doesn't really matter, since it is _ATA_.


It matters quite a bit.  One of the main reasons libata uses the SCSI 
layer is for its infrastructure.

This is the same reason a couple RAID drivers use the SCSI layer.  It 
has nothing to do with SCSI-as-defined-by-T10, and more to do with the 
fact that SCSI provides a robust queueing/EH/block interface infrastructure.

My long term plans include moving some of this not-SCSI-related 
infrastructure from the SCSI layer to the block layer.

	Jeff


