From: Willem Riede <wrlk@riede.org>
Subject: Re: Scsi error handler strategy question
Date: Sun, 4 Jan 2004 21:55:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040105025531.GO4339@linnie.riede.org>
References: <Pine.LNX.4.10.10401041839400.31033-100000@master.linux-ide.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc11.comcast.net ([204.127.202.55]:29878 "EHLO
	sccrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S265855AbUAECzc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jan 2004 21:55:32 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.10.10401041839400.31033-100000@master.linux-ide.org> (from andre@linux-ide.org on Sun, Jan 04, 2004 at 21:42:09 -0500)
List-Id: linux-scsi@vger.kernel.org
To: Andre Hedrick <andre@linux-ide.org>
Cc: linux-scsi@vger.kernel.org

On 2004.01.04 21:42, Andre Hedrick wrote:
> 
> Willem,
> 
> You are free to actually deploy an entire independent eh_strategy series
> of functions.  I never got around to doing it but one of the goals was to
> remove the mid-layer timer and manage it in ide-scsi.
> 
> There is much more that can be done, I just do not have my notes handy.

Andre,

If you are able to locate those notes, I'd be _very_ interested.

Thanks, Willem Riede.
