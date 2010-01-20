From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] scsi: add scsi trace core function and put trace
 points
Date: Wed, 20 Jan 2010 12:42:19 -0500
Message-ID: <1264009339.4561.56.camel@frodo>
References: <4B56A621.2070301@jp.fujitsu.com>
	 <20100120083741.GA5020@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47131 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab0ATRoQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2010 12:44:16 -0500
In-Reply-To: <20100120083741.GA5020@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>

On Wed, 2010-01-20 at 03:37 -0500, Christoph Hellwig wrote:
> > --- linux-2.6.33-rc4-trace/kernel/trace/Makefile~scsi_trace	2010-01-18 16:23:16.000000000 +0900
> > +++ linux-2.6.33-rc4-trace-kei/kernel/trace/Makefile	2010-01-18 16:23:16.000000000 +0900
> > @@ -48,6 +48,9 @@ obj-$(CONFIG_BLK_DEV_IO_TRACE) += blktra
> >  ifeq ($(CONFIG_BLOCK),y)
> >  obj-$(CONFIG_EVENT_TRACING) += blktrace.o
> >  endif
> > +ifneq ($(CONFIG_SCSI),)
> > +obj-$(CONFIG_EVENT_TRACING) += scsitrace.o
> > +endif
> >  obj-$(CONFIG_EVENT_TRACING) += trace_events.o
> >  obj-$(CONFIG_EVENT_TRACING) += trace_export.o
> >  obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
> 
> The code should be built into scsi_mod.ko and thus from drivers/scsi/
> 

Yes, none of this code belongs in kernel/trace/.

-- Steve


