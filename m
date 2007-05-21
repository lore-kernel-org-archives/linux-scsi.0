From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] sd.c: fix refcounting regression in suspend/resume routines
Date: Mon, 21 May 2007 15:59:07 +0200
Message-ID: <4651A5AB.3040003@gmail.com>
References: <Pine.LNX.4.44L0.0705210953040.3974-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.226]:11425 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684AbXEUN7T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 May 2007 09:59:19 -0400
Received: by wr-out-0506.google.com with SMTP id 76so1393677wra
        for <linux-scsi@vger.kernel.org>; Mon, 21 May 2007 06:59:19 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.0705210953040.3974-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> This patch (as909) fixes a couple of refcounting errors in the sd
> driver's suspend and resume methods.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Tejun Heo <htejun@gmail.com>

Thanks.

-- 
tejun
