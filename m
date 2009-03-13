From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Fri, 13 Mar 2009 10:04:38 -0700
Message-ID: <B0A70664-A875-42D9-9A26-B5D8AE4CE450@qlogic.com>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier> <3F3E8B49-EB9A-4A6D-ABB0-3F4FC2EF7D1C@qlogic.com> <BAD9A31D-BCDA-46F9-AE12-E310B684498F@qlogic.com> <49BA8E1E.6080809@linux.vnet.ibm.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:51716 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760778AbZCMREm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2009 13:04:42 -0400
In-Reply-To: <49BA8E1E.6080809@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sven Schuetz <sven@linux.vnet.ibm.com>
Cc: James Smart <James.Smart@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "futjita.tomonori@lab.ntt.co.jp" <futjita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>

Hi Sven,

On Mar 13, 2009, at 9:47 AM, Sven Schuetz wrote:

> Hi Seokmann,
>>
>> Do we have time table for this support to make it available in the
>> upstream?
>> I think it would be good to have the feature in 2.6.30 kernel, if
>> possible.
>> I will continue to work on and add rest of helper function in the  
>> driver.
>>
>> Thank you,
>> Seokmann
>>
>> ---
>
> I am preparing a patch for our zfcp driver and would love to see both
> James&your fc_transport patch as well as the patches for our drivers  
> in
> 2.6.30 too :)
Yeah, that is also my hope, too.
As I get move forward further, I will post updates for rest of work.

Thank you and have a great weekend.

Seokmann
> Tomo, Boaz - since the current implemantation is based on that patch:
> http://marc.info/?l-linux-scsi&m=122785157116659&w=2
> which is not agreed upon - can we start the discussion again?
> My understanding from the discussion back then was that Boaz  
> proposed a
> change to the patch which Tomo agreed to. See here:
> http://marc.info/?l=linux-scsi&m=122812818916080&w=2
> However, a new version of the patch was never posted. So would a patch
> with the proposed change be ok for the two of you which could be  
> posted
> to Jens?
> I really appreciate all of your efforts, thanks a lot for that :-)
> Have a nice weekend,
> Sven

