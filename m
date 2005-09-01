From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] libata new EH document
Date: Thu, 01 Sep 2005 18:27:44 -0400
Message-ID: <43178060.9030601@pobox.com>
References: <20050901043850.15186.qmail@web51611.mail.yahoo.com>	 <43169520.6040008@gmail.com>  <20050901055421.GA23496@havoc.gtf.org> <1125581097.4834.5.camel@mulgrave> <4317755C.5080700@adaptec.com> <431776A0.2030107@pobox.com> <43177C0B.9040500@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43177C0B.9040500@adaptec.com>
Sender: linux-ide-owner@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Tejun Heo <htejun@gmail.com>, ltuikov@yahoo.com, Albert Lee <albertcc@tw.ibm.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Doug Maxey <dwm@maxeymade.com>
List-Id: linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> On 09/01/05 17:46, Jeff Garzik wrote:
> 
>>>>>libata is simply being lazy:  while the SCSI core continues to support
>>>>>kicking the EH thread when sense is missing, it's preferred for libata
>>>>>to reuse that infrastructure.
>>>>
>>>>
>>>>That makes the most sense ;-)
>>>
>>>
>>>For libata it doesn't really matter, since it is _ATA_.
>>
>>It matters quite a bit.  One of the main reasons libata uses the SCSI 
>>layer is for its infrastructure.
> 
> 
> Hmm, maybe I should've been more clear.
> 
> 
>>This is the same reason a couple RAID drivers use the SCSI layer.  It 
>>has nothing to do with SCSI-as-defined-by-T10, and more to do with the 
>>fact that SCSI provides a robust queueing/EH/block interface infrastructure.
> 
> 
> You must be kidding! "robust"?  What are you comparing this to?
> 
> I think it's only because "it's there" and that it provides
> a uniform access -- provided by SCSI, _not_ by that particular
> SCSI implementation.

You're correct in one sense, but I still don't think you understand 
Linux development at a fundamental level.

Linux is NOT about big designs.  Linus says "do what you must, and no 
more."  Linux is a fluid, organic biological organism that evolves 
through small changes over time.

So, yes, the reason is "it's there"   And that's a really good reason!

The future will bring other "baby steps" that evolve us towards a more 
modular design where each LLD may register themselves with a storage 
system, associate themselves with one or more transport classes, which 
in turn create associations with device classes.


>>My long term plans include moving some of this not-SCSI-related 
>>infrastructure from the SCSI layer to the block layer.
> 
> 
> Which is that infrastructure?

Queueing, EH, transport classes (which should already be independent of 
SCSI), maybe driver API, and other fun stuff.  :)

	Jeff


