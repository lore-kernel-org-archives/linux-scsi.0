From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux Kernel 2.4.18 and 2.4.19 problems
Date: Thu, 25 Jul 2002 08:40:01 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1020725083832.11202A-100000@gatekeeper.tmr.com>
References: <20020719225507.GC14331@stud.ntnu.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020719225507.GC14331@stud.ntnu.no>
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Austin Gonyou <austin@digitalroadkill.net>, Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

On Sat, 20 Jul 2002, Thomas [iso-8859-1] Lang=E5s wrote:

> Why?  The vanilla kernel works fine with what we have in production,
> but not with the new P4 Dual Xeon.

I know it's not likely to be related in any way, but did you try bootin=
g
with hyperthreading off? I believe I saw four CPUs in the stuff you
posted, but it's gone now.

--=20
bill davidsen <davidsen@tmr.com>
  CTO, TMR Associates, Inc
Doing interesting things with little computers since 1979.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
