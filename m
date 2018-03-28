From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 1/2] target: drop spin_lock_assert() + irqs_disabled()
 combo checks
Date: Wed, 28 Mar 2018 08:31:38 -0700
Message-ID: <86c1243e-8733-c94d-d8ff-5c299b8266a6@wdc.com>
References: <20180321153854.GB24312@kernel.org>
 <CA+55aFwKN_JijmCt=0S4jF8KzGPmoKNbuYF59va7U4ziJLLryA@mail.gmail.com>
 <20180322093745.GC4229@kernel.org>
 <20180323155513.dwbgvblenlji33as@linutronix.de>
 <1521822325.2535.5.camel@wdc.com>
 <CA+55aFxVkuntSektVmwXktzvfEezdDTAM_zj4DJdp3qJxWf8aA@mail.gmail.com>
 <20180323171736.bcyi2oiolge4l6hl@linutronix.de>
 <20180326111359.180f1604@gandalf.local.home>
 <20180328101553.uduqsdbxwnxrhl7a@linutronix.de>
 <c9f5df1e54bb2bd8f3f0aef86a55deb11888a6a4.camel@wdc.com>
 <20180328151433.elhw6kgxdxq6fn6b@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180328151433.elhw6kgxdxq6fn6b@linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "bigeasy@linutronix.de" <bigeasy@linutronix.de>
Cc: "rostedt@goodmis.org" <rostedt@goodmis.org>, "daniel@bristot.me" <daniel@bristot.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "acme@kernel.org" <acme@kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "williams@redhat.com" <williams@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lclaudio@redhat.com" <lclaudio@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 03/28/18 08:14, bigeasy@linutronix.de wrote:
> On 2018-03-28 15:05:41 [+0000], Bart Van Assche wrote:
>> The names of the two functions touched by patch 1/2 start with a double
>> underscore. That by itself is already a hint that these should be called with
>> a lock held (I know that this is not a universal convention in the Linux
>> kernel). I'm fine either way - either with patch 1/2 as posted or patch 1/2
>> with the above comment added.
> 
> Okay. In that case let me update 1/2.
> But 2/2 with the comment as Steven suggested is still a no no for you?

Although I'm not enthusiast about patch 2/2, if others agree with that 
patch I'm fine with that patch being sent upstream.

Thanks,

Bart.
