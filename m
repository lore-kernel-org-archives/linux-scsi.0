From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi_debug: delay stress fix
Date: Wed, 17 Jan 2018 01:00:01 -0500
Message-ID: <yq1zi5dt47y.fsf@oracle.com>
References: <20180110215731.4805-1-dgilbert@interlog.com>
        <20180110215731.4805-2-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33760 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbeAQGAX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2018 01:00:23 -0500
In-Reply-To: <20180110215731.4805-2-dgilbert@interlog.com> (Douglas Gilbert's
        message of "Wed, 10 Jan 2018 16:57:31 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, bart.vanassche@sandisk.com, hare@suse.de


Doug,

> Introduce a state enum into sdebug_defer objects to indicate which, if
> any, defer method has been used with the associated command.  Also add
> 2 bools to indicate which of the defer methods has been
> initialized. Those objects are re-used but the initialization only
> needs to be done once. This simplifies command cancellation handling.
>
> Now the delay associated with a deferred response of a command cannot
> be changed (once started) by changing the delay (and ndelay)
> parameters in sysfs. Command aborts and driver shutdown are still
> honoured immediately when received.

Applied (by hand, not sure which tree this was cut against?) to
4.16/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
