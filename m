From: Borislav Petkov <bp@amd64.org>
Subject: Re: [RFC PATCH 0/4] Persistent device name using alias name
Date: Wed, 3 Aug 2011 19:16:08 +0200
Message-ID: <20110803171608.GA16116@gere.osrc.amd.com>
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp>
 <20110708145408.GA2283@kroah.com>
 <CAPXgP10gThuxOsrxH8_wOddeRB5f2ABypW7EQui-F1hOE97dHQ@mail.gmail.com>
 <20110708154736.GA7320@kroah.com>
 <1310140451.3282.85.camel@mulgrave>
 <CAPXgP12dA72a3ja659GH6uW+ZCMfL6iECaY6ORXwOQ6S5eTvaQ@mail.gmail.com>
 <4E17F121.3030601@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E17F121.3030601@hitachi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jcm@redhat.com, dle-develop@lists.sourceforge.net, yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com, stefanr@s5r6.in-berlin.de, hare@suse.de, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, Tony Luck <tony.luck@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 09, 2011 at 03:11:45PM +0900, Masami Hiramatsu wrote:
> BTW, I'm also interested in that structured error events, from the long
> term view and viewpoint of tracers :)

Let me chime in a "mee too" from the HW errors perspective.

> I think we could expand current TRACE_EVENT macro to define those
> error events.

Concerning structure, we can use the format file in debugfs which
currently describes the fields of a tracepoint:

/sys/kernel/debug/tracing/events/../../format

and expand those to generic kernel events. Userspace parses the format
and knows exactly at what data it is looking at. Also, the idea is to
move that events hierarchy into sysfs so it will be present on every
system.

Hmm...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
