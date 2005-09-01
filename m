From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC] libata new EH document
Date: Thu, 01 Sep 2005 18:07:17 -0400
Message-ID: <43177B95.4040602@adaptec.com>
References: <20050901043850.15186.qmail@web51611.mail.yahoo.com>	 <43169520.6040008@gmail.com>  <20050901055421.GA23496@havoc.gtf.org>	 <1125581097.4834.5.camel@mulgrave>  <4317755C.5080700@adaptec.com> <1125611718.4946.20.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1125611718.4946.20.camel@mulgrave>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, ltuikov@yahoo.com, Albert Lee <albertcc@tw.ibm.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Doug Maxey <dwm@maxeymade.com>
List-Id: linux-scsi@vger.kernel.org

On 09/01/05 17:55, James Bottomley wrote:
> On Thu, 2005-09-01 at 17:40 -0400, Luben Tuikov wrote:
> 
>>>The current SCSI autosense in drivers doesn't require this because we
>>>reuse the existing command that got the contingent allegiance condition.
>>
>>Care to elaborate what "contingent allegiance condition" is,
>>how SCSI Core got it, how SCSI Core is using it, and how SCSI Core set
>>it up with the LU?
> 
> 
> Well, not really, since it's basic SCSI and the explanation's pretty
> long.  However, the standards have several pages about it.  For your
> reading pleasure, I suggest SAM-2 section 5.9.1 Contingent allegiance
> (CA) and auto contingent allegiance (ACA)

SCSI Core knows nothing about ACA and/or how to use it.

You should also know that no one actually spells out CA or ACA,
they just use the capitalized abbreviation, plus the fact that
CA is obsolete.

Stop impressing the children!

	Luben

