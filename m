From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC PATCH 4/4] convert scsi to blkerr error values
Date: Sat, 17 Sep 2005 10:41:53 -0500
Message-ID: <432C3941.8090002@cs.wisc.edu>
References: <C2EEB4E538D3DC48BF57F391F422779321ACB9@SRMANNING.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36816 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750791AbVIQRmi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Sep 2005 13:42:38 -0400
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321ACB9@SRMANNING.eng.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "goggin, edward" <egoggin@emc.com>
Cc: axboe@suse.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com

goggin, edward wrote:
>>-----Original Message-----
>>From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
>>Sent: Friday, September 16, 2005 4:26 PM
>>To: goggin, edward
>>Cc: axboe@suse.de; linux-scsi@vger.kernel.org; dm-devel@redhat.com
>>Subject: Re: [RFC PATCH 4/4] convert scsi to blkerr error values
>>
>>goggin, edward wrote:
>>
>>>Mike,
>>>
>>>I don't think it is reasonably possible to anticipate
>>>all possible parsing requirements for the asc and ascq
>>>portions of SCSI sense information across all device
>>>models.  I'm in favor of having a "small" framework in
>>>SCSI where a SCSI sense interpreter module (per
>>>vendor & model possibly) could be registered
>>>dynamically, by dm-emc.c for instance.
>>
>>Yeah I agree, I mentioned this before in some other mails. I think a 
>>module versus some table that userspace could write to were discussed.
> 
> 
> Yes, I first heard about this idea from you on one of the multipathing
> cosense. In Lars's comments it stated we may need to send another request nference calls.  I wasn't sure if you were still advocating for this
> approach though :))
> 

To actually implement the vendor specifics, I think I was just being 
lazy and waiting to hear about what people need when they decode the 
sense. In Lars's comments it stated we may need to send another request 
to determine if the paths need to be failed. I think SUN  may have 
wanted the same thing. Any ideas? Did you guys need to do this in your 
multipath solution?
