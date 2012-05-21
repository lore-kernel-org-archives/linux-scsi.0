From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
Date: Mon, 21 May 2012 11:00:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205211059510.1725-100000@iolanthe.rowland.org>
References: <CAF1ivSYmY3d8VonvsX0orsj0fLKXOXsLoG5jSwLs90MoP7=5Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57583 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757173Ab2EUPAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 May 2012 11:00:50 -0400
In-Reply-To: <CAF1ivSYmY3d8VonvsX0orsj0fLKXOXsLoG5jSwLs90MoP7=5Dw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 21 May 2012, Lin Ming wrote:

> On Fri, May 18, 2012 at 2:29 AM, Alan Stern <stern@rowland.harvard.ed=
u> wrote:
> [snip]
> > I may have left some parts out from this brief description. =A0Hope=
fully
> > you'll be able to figure out the general idea and get it to work.
>=20
> All journal threads and flusher thread of the disk need to be freezed
> before suspend and thaw after resume.

Why?  If any of those threads needs to write something to the disk=20
while the disk is suspended, the disk will simply be resumed.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
