From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] firmware/efi: export a routine to retrieve efi-variables
 by GUID
Date: Fri, 18 Mar 2011 16:10:10 -0700
Message-ID: <AANLkTim+HB0GWzGiif=MvYHaiXMSLuVB6R0=UK3906xU@mail.gmail.com>
References: <20110318221606.26841.92271.stgit@localhost6.localdomain6>
	<20110318225016.GB15921@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36363 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab1CRXKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2011 19:10:12 -0400
In-Reply-To: <20110318225016.GB15921@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, linux-kernel@vger.kernel.org, dmilburn@redhat.com, edmund.nadolski@intel.com, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>

On Fri, Mar 18, 2011 at 3:50 PM, Greg KH <gregkh@suse.de> wrote:
>> Not sure who looks after efivars.c, but get_maintainer.pl and git sh=
ortlog
>> fingered Greg as a likely target.
>
> Yes, that is me.

Sorry Greg, didn't mean to refer to you in the third person.

>
>> We are currently targeting a late merge of the isci driver through t=
he
>> staging tree into 2.6.39. =A0This is a pre-requisite to be able to u=
se the
>> driver on an efi enabled platform.
>
> You are? =A0That's news to me, why didn't you ask the staging tree
> maintainer about this?

This was a very recent, two days ago discussion on linux-scsi [1] with
Jeff and Christoph that you should have been copied on...

> I needed all patches in linux-next _before_ the merge window opened t=
o
> be able to accept it.

Yes, I know, and as dmaengine maintainer I also hate being ambushed by
last minute patches, but now I am unfortunately one of those annoying
people on the other side of the coin.

The review has been intermittent until very recently.  Given that
fact, James was understandably not ready to take it into
drivers/scsi/.  So the thought was to leave time for the review to pan
out and then attempt a post -rc1 merge through scsi or staging.

> So, sorry, it will have to wait until .40.
> Please send me the isci driver and I will be glad to queue it up for
> staging for that kernel.

We will submit a revised driver in the next few weeks.

--
Dan

[1]: http://marc.info/?l=3Dlinux-scsi&m=3D130022318906252&w=3D2
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
