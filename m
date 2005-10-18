From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: requesting advice: oops when doing sg_dd IO and device is removed
Date: Tue, 18 Oct 2005 18:02:34 -0400
Message-ID: <009501c5d42f$a5df3f70$e0019d89@cybernetics.com>
References: <4354800D.309@torque.net>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:37124 "EHLO
	cyborg.cybernetics.com") by vger.kernel.org with ESMTP
	id S932160AbVJRWC3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Oct 2005 18:02:29 -0400
In-Reply-To: <4354800D.309@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, "'Dailey, Nate'" <Nate.Dailey@stratus.com>
Cc: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Douglas Gilbert
> Sent: Tuesday, October 18, 2005 12:55 AM
> To: Dailey, Nate
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: requesting advice: oops when doing sg_dd IO and device is
> removed
>
>
> Nate,
> I always suspected that if one really tried hard enough
> then unexpectedly closing a file descriptor (e.g. via
> control-C on an app) at the same time as there are
> outstanding commands could cause problems. Obviously
> you have succeeded demonstrating that with your experiment.
>
> When I fought with this problem in the lk 2.4 series,
> someone skilled at finding flaws in locking logic
> suggested there was no solution (at least the way
> I was doing it) ...
>
> Waiting a close() call (i.e. sg_release() ), potentially
> indefinitely, was very unpopular with application clients.
> The sg driver did that in the old days, and I was abused
> from several quarters (one name springs to mind). So I
> tried to design sg_release() so it wouldn't ever hang
> the application client.
>
> On reflection, I think to allow sg_release() to go
> through quickly, another kernel thread is needed that
> is passed ownership of unfinished commands. What do
> you think?
>
>
> Doug Gilbert

Doug,

Here are some relevant links regarding related problems in the 2.4
kernels.  I am still using 2.4, so I don't know if 2.6 has this problem
or not.

http://bugme.osdl.org/show_bug.cgi?id=3685
http://marc.theaimsgroup.com/?t=108005442700006&r=1&w=2

Anthony J. Battersby
Cybernetics

