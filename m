From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: RE: Scsi midlayer question
Date: Tue, 10 Aug 2004 07:09:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA204CCBDA@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus11.xyratex.com ([65.203.33.11]:37381 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S264767AbUHJOKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2004 10:10:09 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, Arjan van de Ven <arjanv@redhat.com>
Cc: linux-scsi@vger.kernel.org

Let me see if I can grab some resources to give this patch a try.  I
will get back to you ASAP.

Frank Borich
------------------------------------------------------------------
Xyratex Inc.
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
 
 

>>-----Original Message-----
>>From: Marcelo Tosatti [mailto:marcelo.tosatti@cyclades.com] 
>>Sent: Tuesday, August 10, 2004 7:40 AM
>>To: Arjan van de Ven
>>Cc: Frank Borich; linux-scsi@vger.kernel.org
>>Subject: Re: Scsi midlayer question
>>
>>On Tue, Aug 10, 2004 at 10:05:57AM +0200, Arjan van de Ven wrote:
>>> On Mon, Aug 09, 2004 at 07:39:56PM -0300, Marcelo Tosatti wrote:
>>> > >  		BUG();
>>> > 
>>> > Arjan, is this a v2.6 based patch? 
>>> 
>>> no a 2.4.21-era patch
>>> 
>>>  
>>> > v2.4 current doesnt contain such code you are patching...
>>> 
>>> it'll have code quite similar, I mean this code hardly 
>>changed since 
>>> 2.4.0 and 2.6.x until this patch got merged.
>>
>>Should have read the code before replying, OK now I see, its 
>>wli's discover to not handle higher order pages in "reverse 
>>order" but instead in "order", yes?
>>
>>Have you done any tests with it on v2.4 based kernels? 
>>
>>I'm a bit skeptic about it though.
>>
>>Frank, can you try this patch?
>>
>>
>>
>>
>>
