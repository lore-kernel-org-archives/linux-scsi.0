From: Ray Lee <ray-lk@madrabbit.org>
Subject: Re: [GIT PULL] final scsi updates for 2.6.34-rc1
Date: Sat, 13 Mar 2010 11:35:59 -0800
Message-ID: <2c0942db1003131135m1bea386dx4dd7990832cfbfea@mail.gmail.com>
References: <1268242604.22601.25.camel@mulgrave.site> <alpine.LFD.2.00.1003121008420.3719@i5.linux-foundation.org>
	<1268418441.2802.61.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f176.google.com ([209.85.223.176]:39942 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935476Ab0CMTgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Mar 2010 14:36:20 -0500
In-Reply-To: <1268418441.2802.61.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Fri, Mar 12, 2010 at 10:27 AM, James Bottomley wrote:
> I do always have a tree ready in the first days of the merge window. =
=C2=A0It
> was, in fact, here:

[...]

> The slight problem is that I accumulate updates (like almost everyone
> else) from the few days before the merge window opened up until about
> the middle of the second week. =C2=A0That's what goes into the final =
pull,
> plus assorted bug fixes that showed up during the window.

You appear to being using git as a sort of baroque CVS. Fixes that
arrive after the beginning of the merge window should be put into a
separate branch other than the one ready for submission. Features that
arrive after the beginning of the merge window should be placed into
yet another branch destined for the next merge window.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
