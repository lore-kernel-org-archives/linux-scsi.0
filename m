From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla2xxx internal queues
Date: Mon, 20 Mar 2006 07:39:02 -0800
Message-ID: <20060320153902.GB1578@andrew-vasquezs-powerbook-g4-15.local>
References: <2bd90fb70603200656n164084c1m226ad6e64b5c9f73@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:42757 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S965336AbWCTPjI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Mar 2006 10:39:08 -0500
Content-Disposition: inline
In-Reply-To: <2bd90fb70603200656n164084c1m226ad6e64b5c9f73@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "T.Krishnanand" <krishnanand.thommandra@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 20 Mar 2006, T.Krishnanand wrote:

> qla2xxx driver has some internal queues like 'scsi_retry_queue'
> 'retry_queue' 'pending_queue' etc. Cmds in some of these are being
> cleaned up during "eh_abort" (ABORT TASK) but only 'retry_queue' is
> being cleaned up for the "TARGET RESET"  task mgmt cmd.
> 
> Why is it so ? Why aren't cmds in other queues also aborted when
> "TARGET RESET" happens.

Thanks, we'll take a look.

> Generally IMHO all affected cmds in any driver queues must be aborted
> when the driver gets a task mgmt cmd. What am I missing here ?
> 
> Also I saw some patches in the linux-scsi mailing list where you
> suggest removing the internal queuing from the driver and relying on
> fc remote port support. But in the recent driver
> qla2xxx-src-v8.01.04b6.tar.gz I dont see those changes.
> 
> Could u plz throw some light on this.

QLogic continues to distribute its 'standard' driver which includes
failover and GUI support -- this driver is 8.01.04b6.

Additionally (as has been for several years), we have an upstream
offering which contains no (QLogic) failover support.  GUI (our
management tools) are currently being tested with the upstream drivers
sysfs interfaces (compared to IOCTL inputs).

-- 
AV
