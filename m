From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC] SCSI EH document
Date: Wed, 07 Sep 2005 09:12:32 -0400
Message-ID: <431EE740.2090005@adaptec.com>
References: <20050826035326.GA13392@htj.dyndns.org> <431E9F14.7070703@pobox.com> <431ECD91.80407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:7636 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750962AbVIGNMk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 09:12:40 -0400
In-Reply-To: <431ECD91.80407@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James.Bottomley@steeleye.com, albertcc@tw.ibm.com, linux-scsi@vger.kernel.org

On 09/07/05 07:22, Tejun Heo wrote:
>   Hello, Jeff & James.
> 
> Jeff Garzik wrote:
> 
>>Tejun Heo wrote:
>>
>>
>>> Hello, fellow SCSI/ATA developers.
>>>
>>> This is the first draft of SCSI EH document.  This document tries to
>>>describe how SCSI EH works and what choirs should be done to maintain
>>>SCSI midlayer integrity.  It's intended that this document can be used
>>>as reference for implementing either fine-grained EH callbacks or
>>>single eh_strategy_handler() callback.
>>>
>>> I'm pretty sure that I've screwed up in (hopefully) several places,
>>>so please correct me.  Also, I have several places where I'm not sure
>>>or have questions, those are marked with *VERIFY* and *QUESTION*
>>>respectively.  If you know the answer, please let me know.
>>>
>>> Thanks.
>>>
>>>
>>>SCSI EH
>>
>>
>>Although it's up to the SCSI maintainer ultimately, I think it would be 
>>nice to stick this in Documentation/DocBook/ or Documentation/scsi/
> 
> 
>   If James agrees, I'll reformat it to DocBook and submit the patch. 
> James, what do you think?

Add to this the vendor treatment of linux-scsi and lo and behold,
our current situation.

Again: Documentation/ManagamentStyle, Section 1: Decisions.

Any work is good work.  If _you_ think that it should go into
Documentation/scsi, then it probably should.

	Luben

