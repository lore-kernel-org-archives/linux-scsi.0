From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH  0/33][SCSI] Arrange for removal of 'scsi_typedefs.h'
Date: Sun, 06 Jan 2008 22:18:50 +0100
Message-ID: <478145BA.2060207@student.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se> <1199649091.5205.102.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:42850 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbYAFVTF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jan 2008 16:19:05 -0500
In-Reply-To: <1199649091.5205.102.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: kernel-janitors@vger.kernel.org, trivial@kernel.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2008-01-06 at 04:02 +0100, Richard Knutsson wrote:
>   
>> Hi all
>>
>> drivers/scsi/scsi_typedefs.h is about ready to be removed, only the
>> 'struct scsi_cmnd' typedef Scsi_Cmnd is left.
>> This set converts all the Scsi_Cmnd's, except in:
>> Changelogs
>> Documentation/scsi/scsi_mid_low_api.txt
>>
>> So if all these gets merged, in one form or the other, we can:
>> un'include scsi_typedefs.h from drivers/scsi/scsi.h
>> fix the text in Documentation/scsi/scsi_mid_low_api.txt
>> (finally) remove the file in question
>>
>>
>> Left the "over 80 characters wide"-warnings alone, until requested otherwise.
>>
>> Am not subscribed on linux-scsi@vger.kernel.org, so if replying, please Cc: me.
>>     
>
> Actually, a lot of this is superfluous ... the drivers are already
> removed in the scsi-misc-2.6 tree.
>   
When are they be expected to be removed in the mainstream?
> The ideal is to remove this line:
>
> #include "scsi.h"
>
> Because that file (and scsi_typedefs.h) should be expendable by the end
> of all of this (their whole purpose was so we didn't have to convert all
> the typedefs), and then check the thing still compiles---you probably
> have to add in some of the standard #include <scsi/scsi_..> files.
>   
Sounds reasonable.
> Please also don't bother with downcasing Scsi_Cmnd  capitalisation in
> the comments, that's a quirk I'm happy to leave, since it's unambiguous
> in the doc book.
>   
Ok, not like it is a real bother & can't imagine this would be a 
possible source for collision with other patches, but I don't mind 
either way.

Thanks
Richard Knutsson

