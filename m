From: chetan loke <loke.chetan@gmail.com>
Subject: Re: [Lsf-pc] [Topic] Bcache
Date: Wed, 14 Mar 2012 15:22:50 -0400
Message-ID: <CAAsGZS7uU-ojjfwH4+mcENZoNcgrgU4=d6mHDASV0VqGKQ_CRg@mail.gmail.com>
References: <20120314133228.GA2284@dhcp-172-18-216-138.mtv.corp.google.com>
	<20120314155339.GC30235@redhat.com>
	<CAAsGZS6Jw8xCdu3Wuve=iaKpd_UNdm72kbTbiQtypAfrZ46PWw@mail.gmail.com>
	<CAH+dOx+Vgv12w=Q=8hCQggLg+kq6TnT2i3ZtnpZ=bNVyMgk31Q@mail.gmail.com>
	<CAAsGZS5UTrYTbncAjk1Vor6R_-KWDboTw3sh+jXCbXm5q_o-TA@mail.gmail.com>
	<20120314185455.GD28042@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:35968 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab2CNTWu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 15:22:50 -0400
Received: by dadp12 with SMTP id p12so3393650dad.11
        for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 12:22:50 -0700 (PDT)
In-Reply-To: <20120314185455.GD28042@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>, chetan loke <loke.chetan@gmail.com>, Kent Overstreet <koverstreet@google.com>, Vivek Goyal <vgoyal@redhat.com>, lsf-pc@lists.linux-foundation.org, nauman@google.com, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Wed, Mar 14, 2012 at 2:54 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Mar 14, 2012 at 02:33:25PM -0400, chetan loke wrote:
>> But you are not explaining why dm is not the right stack. Just becau=
se
>> it crashed when you tried doesn't mean it's not the right place.
>> flash-cache works, doesn't it? flash-cache's limitation is because
>> it's a dm-target or because it is using hashing or something else?
>> There are start-ups who are doing quite great with SSD-cache+dm. So
>> please stop kidding yourself.
>
> SATA-attached flash is not the only kind of flash out there you know.
> There is also PCIe-attached flash which is a wee bit faster (where we=
e
> is defined as multiple orders of magnitude --- SATA-attached SSD's
> typically have thousands of IOPS; Fusion I/O is shipping product toda=
y
> with hundreds of thousands of IOPS, and has demonstrated a billion
> IOPS early this year). =C2=A0And Fusion I/O isn't the only company sh=
ipping
> PCIe-attached flash products.
>

We've designed linux targets with million IOPS even before PCIe-flash
came into picture you know. So, I think we do know a thing or two
about million IOPS and performance. when I said 'cache' I used it
loosely. The backing store can be anything - a SSD or PCI-e or
adjacent blade over IB.


> Startups may be doing great on SSD's; you may want to accept the fact
> that there is stuff which is way, way, way better out there than
> SSD's which are available on the market *today*.
>
> And it's not like bache which is a new project. =C2=A0It's working co=
de,
> just like flash cache is today. =C2=A0So it's not like it needs to ju=
stify
> its existence.
>

we are talking about approaches and not existence.

> Best regards,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-=
 Ted

BR,
Chetan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
