From: Tony Zelenoff <antonz@parallels.com>
Subject: Re: [PATCH] fcoe: fix compilation warnings of section mismatch
Date: Sat, 30 Jun 2012 09:25:16 +0400
Message-ID: <4FEE8DBC.9060809@parallels.com>
References: <1340713062-126798-1-git-send-email-antonz@parallels.com>  <4FEE0C55.6010704@intel.com> <1341001228.2907.61.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:46417 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab2F3FZV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jun 2012 01:25:21 -0400
In-Reply-To: <1341001228.2907.61.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Love, Robert W" <robert.w.love@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

30/06/12 12:20 AM, James Bottomley =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Fri, 2012-06-29 at 20:13 +0000, Love, Robert W wrote:
>> On 12-06-26 05:17 AM, Tony Zelenoff wrote:
>>
>> Fix this message:
>> WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x21): Section misma=
tch
>> in reference from the function init_module() to the function
>> .exit.text:fcoe_transport_exit()
>> The function __init init_module() references
>> a function __exit fcoe_transport_exit().
>>
>> Signed-off-by: Tony Zelenoff <antonz@parallels.com><mailto:antonz@pa=
rallels.com>
>>
>>
>> Thank you for the patch. However, this was fixed a few weeks ago. Th=
e patch is in James' 'for-next' branch here: http://git.kernel.org/?p=3D=
linux/kernel/git/jejb/scsi.git;a=3Dcommit;h=3D43b8a1613a1c8707d0e86316a=
7d6999fd767a5cf
MAke this patch from linux branch is faster than cloning scsi-next. :)=20
Anyway, if it fixed - it is nice.

>> I'm not sure if it's queue'd up for the current RC phase or not. I d=
on't know how the scsi.git branches are managed. I think the patch shou=
ld go for the current RC.
>
> Show me the bug it actually produces and I'll queue it for -rc ...
It mostly cosmetic issue, there is no reason to port it to RC branches.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
