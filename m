From: Jens Axboe <axboe@suse.de>
Subject: Re: cdrom_ioctl() hanging in 2.6.3
Date: Mon, 23 Feb 2004 22:11:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040223211157.GO32010@suse.de>
References: <20040222134723.7de65a50.akpm@osdl.org> <c1c43f$pm4$1@sea.gmane.org> <c1dlvr$hc3$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:24787 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262055AbUBWVL7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 16:11:59 -0500
Content-Disposition: inline
In-Reply-To: <c1dlvr$hc3$1@sea.gmane.org>
List-Id: linux-scsi@vger.kernel.org
To: Joachim Geiler <Joachim.Geiler@t-online.de>
Cc: linux-scsi@vger.kernel.org

On Mon, Feb 23 2004, Joachim Geiler wrote:
> Joachim Geiler wrote:
> 
> > Andrew Morton wrote:
> > 
> >> 
> >> Gents,
> >> 
> >> apparently KDE's `k3b' command is consistently hanging when accessing a
> >> SCSI CDROM.  See http://bugs.kde.org/show_bug.cgi?id=75553
> >> 
> >> Frank has generated a stack backtrace, below.
> >> 
> >> Is this an adaptec driver problem, or a generic thing?
> >> 
> >> Thanks.
> 
> Hello again,
> 
> I did a strace of the syscalls of k3b before it hangs (kernel 2.6.3mm2). I
> think the following tail of the trace may be of interest:

See the other threads on same list about this, problem has been solved.

-- 
Jens Axboe

