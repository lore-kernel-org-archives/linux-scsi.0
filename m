From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC] SCSI EH document
Date: Wed, 07 Sep 2005 20:22:57 +0900
Message-ID: <431ECD91.80407@gmail.com>
References: <20050826035326.GA13392@htj.dyndns.org> <431E9F14.7070703@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.196]:14540 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932114AbVIGLXG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 07:23:06 -0400
Received: by zproxy.gmail.com with SMTP id r28so972076nza
        for <linux-scsi@vger.kernel.org>; Wed, 07 Sep 2005 04:23:02 -0700 (PDT)
In-Reply-To: <431E9F14.7070703@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James.Bottomley@steeleye.com, luben_tuikov@adaptec.com, albertcc@tw.ibm.com, linux-scsi@vger.kernel.org


  Hello, Jeff & James.

Jeff Garzik wrote:
> Tejun Heo wrote:
> 
>>  Hello, fellow SCSI/ATA developers.
>>
>>  This is the first draft of SCSI EH document.  This document tries to
>> describe how SCSI EH works and what choirs should be done to maintain
>> SCSI midlayer integrity.  It's intended that this document can be used
>> as reference for implementing either fine-grained EH callbacks or
>> single eh_strategy_handler() callback.
>>
>>  I'm pretty sure that I've screwed up in (hopefully) several places,
>> so please correct me.  Also, I have several places where I'm not sure
>> or have questions, those are marked with *VERIFY* and *QUESTION*
>> respectively.  If you know the answer, please let me know.
>>
>>  Thanks.
>>
>>
>> SCSI EH
> 
> 
> Although it's up to the SCSI maintainer ultimately, I think it would be 
> nice to stick this in Documentation/DocBook/ or Documentation/scsi/

  If James agrees, I'll reformat it to DocBook and submit the patch. 
James, what do you think?

-- 
tejun
