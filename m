From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] scsi: add scsi trace core function and put trace
	points
Date: Wed, 20 Jan 2010 03:37:41 -0500
Message-ID: <20100120083741.GA5020@infradead.org>
References: <4B56A621.2070301@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751944Ab0ATIht@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B56A621.2070301@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Frederic Weisbecker <fweisbec@gmail.com>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

> --- linux-2.6.33-rc4-trace/kernel/trace/Makefile~scsi_trace	2010-01-18 16:23:16.000000000 +0900
> +++ linux-2.6.33-rc4-trace-kei/kernel/trace/Makefile	2010-01-18 16:23:16.000000000 +0900
> @@ -48,6 +48,9 @@ obj-$(CONFIG_BLK_DEV_IO_TRACE) += blktra
>  ifeq ($(CONFIG_BLOCK),y)
>  obj-$(CONFIG_EVENT_TRACING) += blktrace.o
>  endif
> +ifneq ($(CONFIG_SCSI),)
> +obj-$(CONFIG_EVENT_TRACING) += scsitrace.o
> +endif
>  obj-$(CONFIG_EVENT_TRACING) += trace_events.o
>  obj-$(CONFIG_EVENT_TRACING) += trace_export.o
>  obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o

The code should be built into scsi_mod.ko and thus from drivers/scsi/
