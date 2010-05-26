From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 6/7] scsi: megaraid_sas - Add three times Online controller
 reset - V2
Date: Wed, 26 May 2010 17:48:04 +0200
Message-ID: <4BFD42B4.90207@redhat.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>	 <3A916D859199814BBB666188F96EB165013979165E@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C3CDB80B82@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C3CDB80C32@cosmail02.lsi.com>	 <4BFBF814.5040202@redhat.com> <1274808736.5300.133.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284Ab0EZPzn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2010 11:55:43 -0400
In-Reply-To: <1274808736.5300.133.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Yang, Bo" <Bo.Yang@lsi.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>

On 05/25/2010 07:32 PM, James Bottomley wrote:
> On Tue, 2010-05-25 at 18:17 +0200, Tomas Henzl wrote:
>   
>> V2: I've cleaned up some coding style issues and removed a variable, the functionality shouldn't be changed
>>
>> Tomas
>>
>> If fw didn't raise the interrupt with the fw state change to driver and fw goes to failure state, driver
>> Will check the FW state in driver's timeout routine and issue the reset if need.  Driver will do the OCR upto three
>> Times until kill adapter.  Also driver will issue OCR before driver kill adapter even if fw in operational state.   
>>     
> So there's supposed to be a replacement for 3/7 (megaraid_sas - Online
> COntroller Reset (OCR) PART-III) as well, isn't there?
>   
Yes, I think there are some issues that could be removed, on the other side
it is mostly coding style related, so I think it could be accepted as it is.
I hope I could afterwards clean something up. (The patches as they are now don't
apply correctly on my system, it's maybe an issue with my mail reader.)
 

> Also descriptive subjects would be nice (parts I-III may do well for
> Lord of the Rings ... it's less useful for SCSI patches).
>   
This is again a question for the original author. Bo?

Tomas


> James
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

