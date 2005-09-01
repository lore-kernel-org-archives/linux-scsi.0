From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC] libata new EH document
Date: Thu, 01 Sep 2005 18:36:49 -0400
Message-ID: <43178281.20203@adaptec.com>
References: <20050901043850.15186.qmail@web51611.mail.yahoo.com>	 <43169520.6040008@gmail.com>  <20050901055421.GA23496@havoc.gtf.org>	 <1125581097.4834.5.camel@mulgrave>  <4317755C.5080700@adaptec.com>	 <1125611718.4946.20.camel@mulgrave>  <43177B95.4040602@adaptec.com> <1125613408.4946.28.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:12949 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1030479AbVIAWg6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2005 18:36:58 -0400
In-Reply-To: <1125613408.4946.28.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, ltuikov@yahoo.com, Albert Lee <albertcc@tw.ibm.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Doug Maxey <dwm@maxeymade.com>

On 09/01/05 18:23, James Bottomley wrote:
> On Thu, 2005-09-01 at 18:07 -0400, Luben Tuikov wrote:
> 
>>>Well, not really, since it's basic SCSI and the explanation's pretty
>>>long.  However, the standards have several pages about it.  For your
>>>reading pleasure, I suggest SAM-2 section 5.9.1 Contingent allegiance
>>>(CA) and auto contingent allegiance (ACA)
>>
>>SCSI Core knows nothing about ACA and/or how to use it.
> 
> 
> I don't recall ever claiming that it did.  The discussion was about how
> the error handler clears contingent allegiance conditions.

:-)

So are you claiming that 
    "the error handler clears contingent allegiance conditions" ?

Please point me to the lines in the source code where it does this
and how it does it.

>>You should also know that no one actually spells out CA or ACA,
>>they just use the capitalized abbreviation, plus the fact that
>>CA is obsolete.
> 
> 
> Lets just say I'm TLA averse.
> 
> 
>>Stop impressing the children!
> 
> 
> Is that what people who constantly refer to standards are trying to do?
> I must say I did wonder ...

Yes, there's a bunch of us here, count DG too.

	Luben
