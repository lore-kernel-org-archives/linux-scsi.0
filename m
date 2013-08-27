From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [RFC][PATCH] Add a flight data recorder for scsi commands
Date: Tue, 27 Aug 2013 18:41:47 -0400
Message-ID: <20130827224147.GD7293@logfs.org>
References: <20130827220325.GB7293@logfs.org>
 <20130827195422.0c23e47d@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:60121 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab3H1APe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2013 20:15:34 -0400
Content-Disposition: inline
In-Reply-To: <20130827195422.0c23e47d@gandalf.local.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 27 August 2013 19:54:22 -0400, Steven Rostedt wrote:
> On Tue, 27 Aug 2013 18:03:25 -0400
> J=C3=B6rn Engel <joern@logfs.org> wrote:
>=20
> > Here is a fun patch in an early state.  Essentially I want to trace
> > scsi commands, which has already been done long ago.  The problem I
> > have is that I care about all the scsi commands for one particular
> > device - without knowing in advance which device it will be.  Once =
I
> > know the device in question, I want to dump the last X commands.
>=20
> Is the device passed to the trace point? If so, you can add a filter =
on
> that device. You can even create a separate buffer to just trace that
> device.

"without knowing in advance which device it will be"

I have to trace all devices, because I don't know the interesting one
ahead of time.  And after the fact, I only care about one device.  So
having per-device trace buffers seems to be The Right Approach(tm).

And having multiple trace buffers is where I cannot easily make my
problem fit your infrastructure. =20

J=C3=B6rn

--
If you're willing to restrict the flexibility of your approach,
you can almost always do something better.
-- John Carmack
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
