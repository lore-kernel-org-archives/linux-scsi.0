From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] Fix thread termination for the SCSI error handler
Date: Fri, 07 Oct 2005 18:19:47 -0400
Message-ID: <4346F483.8040704@adaptec.com>
References: <Pine.LNX.4.44L0.0509181638570.1209-100000@netrider.rowland.org> <1127094214.4847.54.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:33751 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1161006AbVJGWTu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2005 18:19:50 -0400
In-Reply-To: <1127094214.4847.54.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

Did this patch make it in?

After the transition to kthread_*, "rmmod aic94xx" hangs at
"kthread_stop", judging from /proc/<pid>/wchan.

	Luben
-- 
http://linux.adaptec.com/sas/
Disclaimer: Opinions stated in this email are my own, not of my employer.
For inquiries write to: luben_tuikov@adaptec.com.
