From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] iscsi_tcp: Enable any size command
Date: Thu, 05 Jun 2008 10:16:00 -0500
Message-ID: <1212678960.13549.30.camel@localhost.localdomain>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
	 <48348EC0.5080905@cs.wisc.edu> <48353D58.2080109@panasas.com>
	 <4835A150.2000306@cs.wisc.edu> <4835A25E.6050203@cs.wisc.edu>
	 <483A7557.3080907@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56719 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673AbYFEPQF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 11:16:05 -0400
In-Reply-To: <483A7557.3080907@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

On Mon, 2008-05-26 at 11:31 +0300, Boaz Harrosh wrote:
> Let through upto the largest command of 260 defined by the scsi standard.
> iscsi core supports this already. Now that the scsi-ml supports it we can
> start using large commands.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

This Should Be Acked-by not Signed-off-by.  Signed-off-by means you got
a patch from this person and the order of patch transmission is the
signed off by order.   For Mike to have a signed off by at the bottom, I
have to have got the patch from him, not from you.

Also, this doesn't apply against the latest, but I fixed up the
rejections (iscsi has moved from template based to setting variables in
the shost-> initialisation).

James


