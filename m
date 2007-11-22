From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 03/23] SCSI: early detection of medium not present, updated
Date: Thu, 22 Nov 2007 15:29:33 +0900
Message-ID: <474521CD.9070603@gmail.com>
References: <200711212312.lALNCGOZ014111@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:56154 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbXKVG3r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Nov 2007 01:29:47 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3048649wah
        for <linux-scsi@vger.kernel.org>; Wed, 21 Nov 2007 22:29:46 -0800 (PST)
In-Reply-To: <200711212312.lALNCGOZ014111@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, stern@rowland.harvard.edu, albertcc@tw.ibm.com, jens.axboe@oracle.com

akpm@linux-foundation.org wrote:
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

Acked-by: Tejun Heo <htejun@gmail.com>

This should fix polling problems on several devices.

-- 
tejun
