From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 08/13] scsi: move request preps in other
 places into prep_fn()
Date: Tue, 05 Apr 2005 15:19:05 +0900
Message-ID: <42522DD9.7020601@gmail.com>
References: <20050331090647.FEDC3964@htj.dyndns.org>	 <20050331090647.94FFEC1E@htj.dyndns.org>	 <1112292464.5619.30.camel@mulgrave> <20050401052542.GG11318@htj.dyndns.org> <1112639944.5813.66.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.207]:19724 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261571AbVDEGTL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2005 02:19:11 -0400
Received: by wproxy.gmail.com with SMTP id 68so1824380wri
        for <linux-scsi@vger.kernel.org>; Mon, 04 Apr 2005 23:19:10 -0700 (PDT)
In-Reply-To: <1112639944.5813.66.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

  Hello, James.

James Bottomley wrote:
> On Fri, 2005-04-01 at 14:25 +0900, Tejun Heo wrote:
> 
>> Ah.. with later requeue path consolidation patches, all requests get
>>their sense buffer cleared during requeueing, which, IMHO, is more
>>logical.  Moving scsi_init_cmd_errh() should come after the patch.
>>Sorry. :-)
>>
>> I'll make another take of this patchset (maybe subset) after issues
>>are resolved.  I'll split and reorder relocation of scsi_init_cmd_errh
>>then.
> 
> 
> Thanks.  It would help me enormously if you explained what bugs you were
> fixing at the top of each patch,

  Well, I'll try harder.

 > and also only do patchsets that are
> dependent on each other (I already have your serial_numer_at_timeout and
> internal_timeout removal patches in the scsi-misc-2.6 tree).

  No problem.  Do you want me to do that now?  Or is it okay to do the 
next take after you review the request_fn rewrite patch?

  Thanks.

-- 
tejun

