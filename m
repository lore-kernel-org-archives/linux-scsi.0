From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: MVSAS 1669:mvs_abort_task:rc= 5
Date: Wed, 14 Oct 2009 08:51:49 +0000
Message-ID: <73e903670910140151wf21e959q9cf6dd1236630bf5@mail.gmail.com>
References: <200910091141.52303.tfjellstrom@shaw.ca>
	 <200910131939.09039.tfjellstrom@shaw.ca>
	 <e938503f0910132151p20b42459v96800d889f3f63eb@mail.gmail.com>
	 <200910140118.39988.tfjellstrom@shaw.ca>
	 <4AD583DB.2070806@univ-lille2.fr>
	 <73e903670910140147oafebad7h6c68849e0599c21b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f172.google.com ([209.85.221.172]:36622 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbZJNIwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Oct 2009 04:52:25 -0400
Received: by qyk2 with SMTP id 2so9588431qyk.21
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2009 01:51:49 -0700 (PDT)
In-Reply-To: <73e903670910140147oafebad7h6c68849e0599c21b@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Oct 14, 2009 at 7:55 AM, Christian Vilhelm
<christian.vilhelm@univ-lille2.fr>=A0wrote:
>
> Thomas Fjellstrom wrote:
>>
>> On Tue October 13 2009, andy yan wrote:
>>>
>>> I will send you a patch for debugging this issue, please help to tr=
y and
>>> send back the log, thanks!
>>
>> I will do whatever I can to help get this resolved :) I have some C =
skills, but no kernel/device driver experience, so at the very least I =
should be able to do builds and make small changes if needed, in additi=
on to patching and endless reboots ;D
>
> I'm also willing to help.
> The card is not on a production server and the disks connected to the=
 card do not contain any valuable data so I can make any test wanted.
>

=46WIW I have the same card and the same problems. I'll be travelling
the next two weeks +, but after that I can do tests etc.

(Actually I'll probably also be purchasing one of those known-good LSI
PCIe=A0SAS=A0cards discussed in the very recent xfs+md slowdown thread.
Suggest you check it out if you haven't read it.)

- Kristleifur
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
