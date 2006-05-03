From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] fusion - race between mptfc_register_dev and 	mptfc_target_alloc
Date: Wed, 03 May 2006 13:43:03 -0500
Message-ID: <4458F9B7.10201@sgi.com>
References: <664A4EBB07F29743873A87CF62C26D700C6921@NAMAIL4.ad.lsil.com> <1146679737.3346.77.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:12468 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1750720AbWECSnK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2006 14:43:10 -0400
In-Reply-To: <1146679737.3346.77.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org, jeremy@sgi.com, gwh@sgi.com

I think it's implicit in both the private email I included and Eric's
posting of 05/01/2006 at 13:10PM (CDT).

> Based on a private email from Eric Moore, I'm providing his sign-off.
> 
>> > Mike - Pls go ahead with posting this patch
>> > to linux-scsi@ and bugzilla 170314.   Steve Shirron
>> > has reveiwed this, and I believe they will be testing
>> > the latest drivers as well.
>> >
>> > I'm not going to have time today to post
>> > this, and next week I have Jury Duty.
>> >
>> > Eric
> 
> 

http://marc.theaimsgroup.com/?l=linux-scsi&m=114650712415619&w=2

Doesn't mean that Eric won't provide what you need....

Mike



James Bottomley wrote:
> On Mon, 2006-05-01 at 12:10 -0600, Moore, Eric wrote:
>> On Monday, May 01, 2006 12:07 PM, Micheal Reed wrote: 
>>> This patch applies to 2.6.17-rc3 after applying these patches from
>>> scsi-rc-fixes-2.6.git.
>>>
>>>    [SCSI] mptfusion: bug fix's for raid components adding/deleting
>>>    [SCSI] - fusion - mptfc bug fix's to prevent deadlock situations
>>>    [SCSI] fusion - bug fix stack overflow in mptbase
> 
> Is there an Ack for this patch?
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
