From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: QLogic (qla2100 / qlogicfc)
Date: Wed, 10 Mar 2004 09:48:57 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0403100941460.28488-100000@sweetums.bluetronic.net>
References: <20040310053950.GA25105@praka.local.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sweetums.bluetronic.net ([24.199.150.42]:29169 "EHLO
	sweetums.bluetronic.net") by vger.kernel.org with ESMTP
	id S262649AbUCJOve (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 09:51:34 -0500
In-Reply-To: <20040310053950.GA25105@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>

On Tue, 9 Mar 2004, Andrew Vasquez wrote:
>Yes, but even before the timeouts occur, there appear to be some
>questionable events occuring with the firmware:
>
>	qla2100 0000:06:03.0: ISP System Error - mbx1=18d1h mbx2=ch mbx3=11h.
>	qla2100 0000:06:03.0: Failed to dump firmware (256)!!!
>	qla2x00: DPC handler waking up
>	scsi(0): DPC handler
>	scsi(0): dpc: sched qla2x00_abort_isp ha = f71481d4
>	qla2100 0000:06:03.0: Performing ISP error recovery - ha= f71481d4.

That only happened once and did recover.  The console output doesn't have
timestamps; the system error occured about 20min before the dropped command.

>The ISP2100 has not been a supported chip for some time now, but, I'll
>see if I can get some information from the firmware group regarding
>the events that led-up to this system-error.

That may be, but it's still one of the most widely deployed FC cards on the
market. (however, LSI's fusion MPT has a growing following.)

>I've also been gathering a short-dozen or so patches that I was
>planning on forwarding to linux-scsi towards the end of the week.
>When I get in tomorrow, I'd like to forward you a couple of them for
>some additional testing, if you don't mind?

Fire away.  The system is still running i/o benchmarks (1mil 6G files takes
awhile)

>I appreciate your initiative in enabling some of the debug settings of
>the driver and posting the resultant messages, it certainly makes
>troubleshooting problems a bit easier.

Note, minicom.cap-1 isn't there. :-) I turned on a little too much debugging
and left it on for an entire array resync.

--Ricky


