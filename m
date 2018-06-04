From: "bigeasy@linutronix.de" <bigeasy@linutronix.de>
Subject: Re: [PATCH 1/2] target: drop spin_lock_assert() + irqs_disabled()
 combo checks
Date: Mon, 4 Jun 2018 09:16:06 +0200
Message-ID: <20180604071605.frpptubbfxt2ngk7@linutronix.de>
References: <1521822325.2535.5.camel@wdc.com>
 <CA+55aFxVkuntSektVmwXktzvfEezdDTAM_zj4DJdp3qJxWf8aA@mail.gmail.com>
 <20180323171736.bcyi2oiolge4l6hl@linutronix.de>
 <20180326111359.180f1604@gandalf.local.home>
 <20180328101553.uduqsdbxwnxrhl7a@linutronix.de>
 <c9f5df1e54bb2bd8f3f0aef86a55deb11888a6a4.camel@wdc.com>
 <20180328151433.elhw6kgxdxq6fn6b@linutronix.de>
 <86c1243e-8733-c94d-d8ff-5c299b8266a6@wdc.com>
 <20180528143518.f46hyhi5r5jd3oxe@linutronix.de>
 <92633c987a900acf5e7defb481d347a9e5b1253d.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <92633c987a900acf5e7defb481d347a9e5b1253d.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "daniel@bristot.me" <daniel@bristot.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "acme@kernel.org" <acme@kernel.org>, "williams@redhat.com" <williams@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lclaudio@redhat.com" <lclaudio@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2018-06-04 07:02:15 [+0000], Bart Van Assche wrote:
> 
> Would adding WARN_ON_ONCE(!irqs_disabled()) work fine with an RT kernel?

no, because the interrupts are not disabled at this point on RT.
Lockdep works fine on RT.

> Thanks,
> 
> Bart.

Sebastian
