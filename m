From: "T. Smith" <tlsmith3777@gmail.com>
Subject: runaway latency detection
Date: Sun, 21 Aug 2016 21:22:37 -0500
Message-ID: <8E6107F3-E531-44C2-85B8-C83A35C924DF@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "irqbalance@lists.infradead.org" <irqbalance@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Trying to isolate PREEMPT_RT (full preemption) runaway latency conditions se=
en when using the cyclictest on the 4.1.8 SMP PREEMPT_RT kernel.  Seen avera=
ge latency of 3uS, but runaway or outlier max latency random spikes seem ind=
eterminate.  Noted 72uS with one run of the cyclictest for example. Is this a=
 known issue, the cause understood, and is there a patch for this?   This is=
 on ARM8 Cortex-A53 four core. Running the cyclictest on an isolated core 2 o=
r 3 shows same behavior as do other platforms.  No Trusted OS configured.

The goal is to isolate causes of indeterminism when using the PREEMPT_RT ker=
nel configuration with full preemption and to characterize latency and jitte=
r using ftrace, any recommendations on catching random latency spikes using f=
trace or profiling when running the cyclictest?=
