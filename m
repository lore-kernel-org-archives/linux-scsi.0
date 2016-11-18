From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mptfusion: Fix printk continuations
Date: Thu, 17 Nov 2016 20:50:03 -0500
Message-ID: <yq1mvgx7e0k.fsf@sermon.lab.mkp.net>
References: <20161117204620.GA10093@p100.box>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <20161117204620.GA10093@p100.box> (Helge Deller's message of
        "Thu, 17 Nov 2016 21:46:20 +0100")
Sender: linux-parisc-owner@vger.kernel.org
To: Helge Deller <deller@gmx.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-parisc@vger.kernel.org, John David Anglin <dave.anglin@bell.net>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Helge" == Helge Deller <deller@gmx.de> writes:

Helge> Fix the printk continuations when running the mptfusion driver.
Helge> This patch brings the capabilities into one single syslog line
Helge> again:
Helge>    mptbase: ioc1: Initiating bringup ioc1: LSI53C1030 B2:
Helge>    Capabilities={Initiator,Target} scsi host3: ioc1: LSI53C1030
Helge>    B2, FwRev=01032341h, Ports=1, MaxQ=255, IRQ=67

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
