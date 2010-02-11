From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: MVSAS status
Date: Thu, 11 Feb 2010 09:50:17 +0000
Message-ID: <73e903671002110150h3c4ae0dcq17625f6d9b545bf4@mail.gmail.com>
References: <loom.20100210T002935-813@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:56838 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab0BKJuj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2010 04:50:39 -0500
Received: by fxm20 with SMTP id 20so932700fxm.21
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2010 01:50:37 -0800 (PST)
In-Reply-To: <loom.20100210T002935-813@post.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Orion Poplawski <orion@cora.nwra.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Feb 9, 2010 at 11:32 PM, Orion Poplawski <orion@cora.nwra.com> =
wrote:
>
> What's the status of the MVSAS patches posted in November '09? =A0I'm=
 just trying
> to get started with mvsas and running into the mvs_abort_task issue. =
=A0At least
> one person has reported that stability improved, but it looks like th=
ere were
> some other issues with the patches. =A0Any chance on seeing this in t=
he mainline
> kernel soon? =A0Are there updated versions? =A0A git tree to pull fro=
m?
>

As far as I know, the patches from November were rejected because the
patches themselves weren't solid enough - meaning there were some
cross-references between each of the seven patches, things like that.
The functionality was fine, at least a definite improvement. Ideally,
there would have been another set of patches to top things up and
really get everything running smoothly.

I haven't come across any patch traffic for the card after that Novembe=
r batch.

In the interests of getting these amazingly cheap and effective cards
running properly on Linux, it would be extremely good if someone
experienced with Linux patches would get involved in the matter with
Mr. Andy Yan from Marvell, straighten things out, get the ball rolling
and make the driver stick in mainline. When I emailed him, Mr. Yan was
very helpful and sent me the patches and some info. I tried to fix the
patches myself but was in over my head. And had no time. Etc.

These cards have been recommended for ZFS use on Solaris backed with
solid arguments, so the hardware is definitely fine [1].

I will PERSONALLY buy two of these cards to send to any reasonably
experienced Linux driver programmer willing to help finish these
drivers. My company will buy two more, and I'm sure there is enough
latent interest out there to get any number of development machines
packed with these cards. This is the perfect case for open-source
development, we just need a solid prospect that the driver issues can
be nailed.

-- Kristleifur


[1] - http://jmlittle.blogspot.com/2008/06/recommended-disk-controllers=
-for-zfs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
