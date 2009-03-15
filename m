From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Sun, 15 Mar 2009 11:34:59 +0200
Message-ID: <49BCCBC3.7020204@panasas.com>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier> <3F3E8B49-EB9A-4A6D-ABB0-3F4FC2EF7D1C@qlogic.com> <BAD9A31D-BCDA-46F9-AE12-E310B684498F@qlogic.com> <49BA8E1E.6080809@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:8844 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753399AbZCOJf6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Mar 2009 05:35:58 -0400
In-Reply-To: <49BA8E1E.6080809@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sven Schuetz <sven@linux.vnet.ibm.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>, James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, futjita.tomonori@lab.ntt.co.jp, Giridhar Malavali <giridhar.malavali@qlogic.com>

Sven Schuetz wrote:
> Hi Seokmann,
>> Do we have time table for this support to make it available in the 
>> upstream?
>> I think it would be good to have the feature in 2.6.30 kernel, if 
>> possible.
>> I will continue to work on and add rest of helper function in the driver.
>>
>> Thank you,
>> Seokmann
>>
>> ---
> 
> I am preparing a patch for our zfcp driver and would love to see both 
> James&your fc_transport patch as well as the patches for our drivers in 
> 2.6.30 too :)
> 
> Tomo, Boaz - since the current implemantation is based on that patch:
> http://marc.info/?l-linux-scsi&m=122785157116659&w=2
> which is not agreed upon - can we start the discussion again?
> My understanding from the discussion back then was that Boaz proposed a 
> change to the patch which Tomo agreed to. See here: 
> http://marc.info/?l=linux-scsi&m=122812818916080&w=2
> However, a new version of the patch was never posted. So would a patch 
> with the proposed change be ok for the two of you which could be posted 
> to Jens?
> I really appreciate all of your efforts, thanks a lot for that :-)
> Have a nice weekend,
> Sven

My humble opinion is: That none of the patches should go in. It is easy
enough to use the API as it is, and it is more correct then any of the
suggested alternatives.

Please point me to the latest code-base and I'll fix you a patch that I
think looks very simple and will work well.

Cheers, have a good day
Boaz
