From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [RFC] [PATCH] 0/7 2.5.35 SCSI multi-path
Date: Thu, 19 Sep 2002 17:16:43 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1020919171118.24603A-100000@gatekeeper.tmr.com>
References: <20020918090802.B14245@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20020918090802.B14245@eng2.beaverton.ibm.com>
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Brian Waite <waite@skycomputers.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 18 Sep 2002, Patrick Mansfield wrote:

> Devices without serial numbers are treated as if they had different serial
> numbers, they show up as if there was no multi-path support.

That doesn't solve the problem, does it? If you have two devices w/o
serial they could look like one with multipath, with the change you note
that is prevented by making a single multipath device w/o serial look like
two. I have visions of programs using /dev/st0 and /dev/st1, having used
backup programs which grabbed every drive with a tape ready.

It is indeed a messy problem.

-- 
bill davidsen <davidsen@tmr.com>
  CTO, TMR Associates, Inc
Doing interesting things with little computers since 1979.
