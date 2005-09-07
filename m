From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] SCSI EH document
Date: Wed, 07 Sep 2005 04:04:36 -0400
Message-ID: <431E9F14.7070703@pobox.com>
References: <20050826035326.GA13392@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:25580 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932078AbVIGIEp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 04:04:45 -0400
In-Reply-To: <20050826035326.GA13392@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James.Bottomley@steeleye.com, luben_tuikov@adaptec.com, albertcc@tw.ibm.com, linux-scsi@vger.kernel.org

Tejun Heo wrote:
>  Hello, fellow SCSI/ATA developers.
> 
>  This is the first draft of SCSI EH document.  This document tries to
> describe how SCSI EH works and what choirs should be done to maintain
> SCSI midlayer integrity.  It's intended that this document can be used
> as reference for implementing either fine-grained EH callbacks or
> single eh_strategy_handler() callback.
> 
>  I'm pretty sure that I've screwed up in (hopefully) several places,
> so please correct me.  Also, I have several places where I'm not sure
> or have questions, those are marked with *VERIFY* and *QUESTION*
> respectively.  If you know the answer, please let me know.
> 
>  Thanks.
> 
> 
> SCSI EH

Although it's up to the SCSI maintainer ultimately, I think it would be 
nice to stick this in Documentation/DocBook/ or Documentation/scsi/

	Jeff


