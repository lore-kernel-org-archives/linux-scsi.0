From: "Haofeng Kou" <haofengk@ptu.promise.com>
Subject: Tasklet, TaskQ and Int
Date: Wed, 24 Jul 2002 20:54:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F6A3AFC9BCD92E48B79C14E4AAAEA20F45A51C@nonamea.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I meet some problems in my RAID system developing.
As we know , Linux Kernel schedule methods:
1> Task Queues: <1>Scheduler queue; <2>Timer queue; <3>Immediate queue
2> Tasklet
3> Kernel timer


I have questions about the "Tasklet",  "Scheduler queue" and the
Interrupt:
1> For "Tasklet" and "Scheduler queue" tasks, do they have the priority,
which one is more higher and how does the kernel deal with this?
2> For example that if the Interrupt happen during the "Scheduler queue"
task, then Interrupt finish and schedule another "Tasklet". At this
time, I want the "Tasklet" can execute before this "Scheduler queue"
task, is it possible? How to handle it?


Thanks,
haofeng


