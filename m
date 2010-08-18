From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Fwd: Re: [Scst-devel] linuxcon 2010...
Date: Wed, 18 Aug 2010 21:52:01 +0400
Message-ID: <4C6C1DC1.8090208@vlnb.net>
References: <4C69653E.6050808@vlnb.net> <1282077040.16098.47.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60948 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab0HRRv6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2010 13:51:58 -0400
In-Reply-To: <1282077040.16098.47.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

James Bottomley, on 08/18/2010 12:30 AM wrote:
>> 1. What don't you like in the transition path for users from STGT to
>> SCST, which I proposed:
>>
>>    - The only people which would be affected by replacing of STGT by SCST
>> would be users of ibmvstgt. Other STGT users would not notice it at all.
>> Thus, we should update ibmvstgt for SCST. If ibmvstgt updated for SCST,
>> the update for its users would be just writing of a simple scstadmin's
>> config file.
>>
>>    - STGT doesn't have backend drivers, which SCST doesn't have, so
>> there's nothing to worry here. At max, AIO support should be added to
>> fileio_tgt.
>>
>>    - STGT user space targets can use SCST backend via scst_local module.
>> Scst_local module is ready and work very well.
>>
>> The result would be very clear without any obsolete mess.
>
> So does that get us up to being a drop in replacement?  I think you're
> saying that even with all of this, at least the VSCSI part will need
> updating, so the answer seems to be "no".

Sorry, I can't understand, "no" for which? For the whole transition 
path, or just until there is a patch for ibmvstgt to become ibmvscst?

>> 4. Have you changed your opinion that a driver level multipath is
>> forbidden in Linux and now you think that an iSCSI target with MC/S
>> support is acceptable?
>
> no; I still think MCS is a pointless duplication of multipath that only
> works for iSCSI.

Then, does it mean that similarly as it was with open-iscsi, which had 
to remove MC/S support to be able to be accepted into the mainline, an 
iSCSI target can't go into mainline if it has MC/S?

Thanks for answers,
Vlad
