From: Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH] target: Use WARNON_NON_RT(!irqs_disabled())
Date: Mon, 26 Mar 2018 11:21:36 -0300
Message-ID: <20180326142136.GD18897@kernel.org>
References: <20180321153854.GB24312@kernel.org>
 <CA+55aFwKN_JijmCt=0S4jF8KzGPmoKNbuYF59va7U4ziJLLryA@mail.gmail.com>
 <20180322093745.GC4229@kernel.org>
 <20180323155513.dwbgvblenlji33as@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180323155513.dwbgvblenlji33as@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, linux-rt-users <linux-rt-users@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Daniel Bristot de Oliveira <daniel@bristot.me>, Luis Claudio =?iso-8859-1?Q?R=2E_Gon=E7alves?= <lclaudio@redhat.com>, Clark Williams <williams@redhat.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Em Fri, Mar 23, 2018 at 04:55:13PM +0100, Sebastian Andrzej Siewior escreveu:
> Arnaldo, please do "[PATCH RT]" while sending patches. Then the bots
> don't complain if it applies but does not compile on !RT kernel (or so
> I've been told).

Ok, I'll try to remember that for future patches.

- Arnaldo
