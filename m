From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
Date: Thu, 30 Apr 2009 14:15:48 -0700
Message-ID: <e9c3a7c20904301415t621670a0l1bd64c7d74d369f@mail.gmail.com>
References: <1233456951-992-1-git-send-email-tj@kernel.org>
	 <49F902CF.7080307@garzik.org> <49F903DD.8040707@kernel.org>
	 <49FA0349.3090706@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:26471 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbZD3VPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2009 17:15:49 -0400
In-Reply-To: <49FA0349.3090706@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Mauelshagen@redhat.com, dm-devel@redhat.com

On Thu, Apr 30, 2009 at 1:00 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Tejun Heo wrote:
>>
>> Hello,
>>
>> Jeff Garzik wrote:
>>>
>>> <shrug> =A0I suppose...
>>>
>>> It just seems like a nasty hack, but unfortunately I don't see
>>> anyone stepping up to do it properly -- with a DM device
>>> automatically layered on top that splits the device into separate
>>> regions: one block device for the 'regular' area, and one for the
>>> HPA.
>>
>> Isn't that more hacky? =A0I don't know. =A0All that dm needs to know=
 is
>> the location of the metadata which is located w.r.t. the end of the
>> device which might be at a different location if BIOS tried to pull
>> silly stunts. =A0So, exporting the size BIOS might have used seems l=
ike
>> a straight forward solution to me.
>
> "<shrug> I suppose" is basically a reluctant ack, in the absence of o=
ther
> solutions :)
>

Couldn't the "fix" also just be a note to users to disable ignore_hpa
if they notice that there raid arrays are not assembling correctly?

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
