From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1] scsi: Don't select SCSI_PROC_FS by default
Date: Thu, 20 Jun 2019 17:47:01 -0400
Message-ID: <yq1muicq696.fsf@oracle.com>
References: <2de15293-b9be-4d41-bc67-a69417f27f7a@free.fr>
        <621306ee-7ab6-9cd2-e934-94b3d6d731fc@acm.org>
        <fb2d2e74-6725-4bf2-cf6c-63c0a2a10f4f@interlog.com>
        <alpine.LNX.2.21.1906181107240.287@nippy.intranet>
        <017cf3cf-ecd8-19c2-3bbd-7e7c28042c3c@free.fr>
        <f8339103-5b45-b72d-9f87-fd4dd7b3081e@interlog.com>
        <f1f98ab0-399a-6c12-073d-ee8ad47d5588@free.fr>
        <48912bc0-8c79-408d-7ed2-c127b99b8bcc@interlog.com>
        <e04e14b7-e1ee-c0c1-9e6d-2628d2c873a9@free.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e04e14b7-e1ee-c0c1-9e6d-2628d2c873a9@free.fr> (Marc Gonzalez's
        message of "Thu, 20 Jun 2019 11:01:39 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Finn Thain <fthain@telegraphics.com.au>, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org


Marc,

> (I work on smaller systems where we do use /proc occasionally, but we
> don't enable CHR_DEV_SG or SCSI_PROC_FS.)

Many sg apps depend on SCSI_PROC_FS. That doesn't imply that only sg
apps depend on it.

As an example, with SCSI_PROC_FS enabled we don't need your SanDisk
Cruzer Blade patch at all since you can tweak the blacklist flags from
user space.

Also, the "legacy" moniker was wishful thinking. Applied to the Kconfig
option at a time where sysfs was new and shiny and considered the
solution to all the kernel's problems. But that wholesale transition of
all interfaces from /proc simply never took place. What happened was
that *new* functionality largely went to sysfs.

Note that I don't have a problem adding missing knobs to sysfs where it
makes sense. But it will obviously take a while for userland apps to
adopt it.

-- 
Martin K. Petersen	Oracle Linux Engineering
