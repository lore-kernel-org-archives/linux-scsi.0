From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: vpd pages are mandatory for SPC-2
Date: Tue, 15 Mar 2016 18:19:21 +0100
Message-ID: <56E84419.3040109@interlog.com>
References: <1457703965-71028-1-git-send-email-hare@suse.de>
 <yq137rshbrr.fsf@sermon.lab.mkp.net> <56E7B9AA.3020302@suse.de>
 <20160315074232.GA10944@lst.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:45046 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934740AbcCORT0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2016 13:19:26 -0400
In-Reply-To: <20160315074232.GA10944@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.com>

On 16-03-15 08:42 AM, Christoph Hellwig wrote:
> On Tue, Mar 15, 2016 at 08:28:42AM +0100, Hannes Reinecke wrote:
>> But it feels even sillier having to whitelist every
>> standards-conformant device here; I certainly was when I figured
>> that EMC Clariion won't work properly without this patch.
>>
>> And the idea was to mark off _misbehaving_ drives, not the other way
>> round.
>
> It's the idea, but it has to prove workable as well in the end.
>
> That being said I'd prefer to allow Hannes patch in and see what
> the fallout is.

I don't have many drafts archived for SPC-2 but the two that I do have:
    spc2r18.pdf [20000521]
    spc2r20.pdf [20010718]

indicate that those two VPD pages were made mandatory right at the
end of the draft cycle for SPC-2. spc2r20.pdf was the last draft
prior to the standard and it does show them as mandatory in table 185
on page 218. The corresponding table in spc2r18.pdf does not have
a column indicating whether the listed VPD pages are mandatory or
not (or words that I can find in the description of VPD pages 0x0
and 0x83 to suggest they are mandatory).

Doug Gilbert
