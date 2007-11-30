From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch] SCSI: early detection of medium not present, updated
Date: Fri, 30 Nov 2007 09:04:45 +0900
Message-ID: <474F539D.8000206@gmail.com>
References: <20071129151842.44c05b18.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:56284 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763601AbXK3AE5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Nov 2007 19:04:57 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2454164wah
        for <linux-scsi@vger.kernel.org>; Thu, 29 Nov 2007 16:04:52 -0800 (PST)
In-Reply-To: <20071129151842.44c05b18.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Albert Lee <albertcc@tw.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <jens.axboe@oracle.com>

Andrew Morton wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> Taken from http://bugzilla.kernel.org/show_bug.cgi?id=8904
> 
> An updated (by Albert, I assume) version of the fourteen-month-old patch here:
> 
> http://marc.info/?l=linux-kernel&m=115412002912837&w=2
> 
> Apparently fixes the bug described at
> http://bugzilla.kernel.org/show_bug.cgi?id=8904
> 
> Needs some TLC.  Perhaps urgently.
> 
> Cc: Albert Lee <albertcc@tw.ibm.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Cc: Tejun Heo <htejun@gmail.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I think I did it last time but...

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
