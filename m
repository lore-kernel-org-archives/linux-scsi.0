From: Luben Tuikov <luben@splentec.com>
Subject: Re: Possible bug handling bad I/Os?
Date: Thu, 29 Aug 2002 15:16:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D6E731F.CE4C3A1F@splentec.com>
References: <20020829124142.D31625@redhat.com> <B993CDEB.2C0F%mheinz@infiniconsys.com> <20020829132728.G31625@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g7TJGjH27761
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2002 15:16:45 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Doug Ledford wrote:
> 
> 
> Yep.  It's the queue starvation issue that someone else brought up (can't
> remember who that was...).  Basically, if you don't have some outstanding
> command that will complete after you fail your queue_command() call then
> there is no method of goosing the current holding queue in the mid layer.
> It doesn't have a timer backup goose method as of yet.
> 

How hard would that be to add?

Wouldn't it be an implied implementation as per SAM-3 status codes?
(One can do magic using the new list implementation and macros... :-)

-- 
Luben
