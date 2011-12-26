From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 12/14] ib_srp: Rework error handling
Date: Mon, 26 Dec 2011 19:13:38 +0000
Message-ID: <CAO+b5-qaMDNHz31K6pBaCqp6hFhPbnUNNwejnF6+RkzSwwsGzA@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112012010.37276.bvanassche@acm.org>
	<1324265791.17849.92.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1324265791.17849.92.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 19, 2011 at 3:36 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote=
:
> On Thu, 2011-12-01 at 20:10 +0100, Bart Van Assche wrote:
> > =A0/*
> > =A0 * Copyright (c) 2005 Cisco Systems. =A0All rights reserved.
> > + * Copyright (c) 2010-2011 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>.
>
> You've tried to add this in the past; I don't mean to deny you credit=
,
> and I certainly value your work, but I'm not sure where the threshold=
 is
> for adding a copyright line.

The excerpts below might provide some guidance (source: "The Copyright
Handbook: What Every Writer Needs to Know"):
[ ... ]
There are strict technical requirements as to what a copyright notice
must contain. Follow these rules exactly or your notice may be found
to be invalid and not accomplish its intended purpose. A valid
copyright notice contains three elements:
* the copyright symbol
* the year in which the work was published
* the name of the copyright owner.
It is not required that these elements appear in any particular order
in the notice, but most notices are written in the order set forth
above. We'll discuss each element in turn.
[ ... ]
If there are multiple authors, they should all be listed in the
copyright notice. The authors' names can appear in any order.
[ ... ]

If I interpret the above correctly, at least two names are missing in
the copyright header of the source file ib_srp.c.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
