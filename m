From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: OOPS: unplugging western digital passport drive
Date: Tue, 5 Jan 2016 10:24:05 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1601051020280.1666-100000@iolanthe.rowland.org>
References: <CAFrYPTP0B5Hxf7PJhYDOt5GHSjZopdBM_91tL5=6S5=1YU+9PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60360 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752185AbcAEPYG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2016 10:24:06 -0500
In-Reply-To: <CAFrYPTP0B5Hxf7PJhYDOt5GHSjZopdBM_91tL5=6S5=1YU+9PQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?Q?Stanis=C5=82aw_Pitucha?= <viraptor@gmail.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 5 Jan 2016, Stanis=C5=82aw Pitucha wrote:

> Hi Alan,
> I'm really sorry, I completely forgot the emails after return.
> I just rechecked on 4.2.5-1 and I cannot reproduce the oops anymore.
> (originally the issue was on 3.18.6-1) Plugging/unplugging the same d=
rive
> works just fine now.
>=20
> Checking against the current linux master it looks like the patch you=
 sent
> in this thread was not merged though...
> From my perspective it's "works for me" now, but if you'd like me to =
retest
> any changes, I'm happy to do that. Let me know!

The patch I sent to you was merged in August.  But then it caused other
problems, so it was reverted in December and a different fix was merged
instead (commit 4fd41a8552af).  That new fix hasn't migrated into the
=2Estable kernels yet.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
