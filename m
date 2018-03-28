From: "bigeasy@linutronix.de" <bigeasy@linutronix.de>
Subject: Re: [PATCH 1/2] target: drop spin_lock_assert() + irqs_disabled()
 combo checks
Date: Wed, 28 Mar 2018 12:15:54 +0200
Message-ID: <20180328101553.uduqsdbxwnxrhl7a@linutronix.de>
References: <20180321153854.GB24312@kernel.org>
 <CA+55aFwKN_JijmCt=0S4jF8KzGPmoKNbuYF59va7U4ziJLLryA@mail.gmail.com>
 <20180322093745.GC4229@kernel.org>
 <20180323155513.dwbgvblenlji33as@linutronix.de>
 <1521822325.2535.5.camel@wdc.com>
 <CA+55aFxVkuntSektVmwXktzvfEezdDTAM_zj4DJdp3qJxWf8aA@mail.gmail.com>
 <20180323171736.bcyi2oiolge4l6hl@linutronix.de>
 <20180326111359.180f1604@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180326111359.180f1604@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "acme@kernel.org" <acme@kernel.org>, "daniel@bristot.me" <daniel@bristot.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "williams@redhat.com" <williams@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lclaudio@redhat.com" <lclaudio@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2018-03-26 11:13:59 [-0400], Steven Rostedt wrote:
> > diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> > index 9c7bc1ca341a..3d35dad1de2c 100644
> > --- a/drivers/target/target_core_tmr.c
> > +++ b/drivers/target/target_core_tmr.c
> 
> Can you add a comment above the functions though?
> 
> /* Expects to have se_cmd->se_sess->sess_cmd_lock held */

I could. I haven't heard from Bart / Nicholas about their opinion. I
know, we do this other places but Bart was against this kind of
annotation in 2/2 of this thread.
So I am waiting to hear from them :)

> 
> -- Steve

Sebastian
