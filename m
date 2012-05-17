From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/4] SCSI, classes, mpt2sas: have scsi_internal_device_unblock
 take new state
Date: Thu, 17 May 2012 10:15:33 -0500
Message-ID: <4FB51615.9060705@cs.wisc.edu>
References: <1336127004-2358-1-git-send-email-michaelc@cs.wisc.edu>  <1336127004-2358-3-git-send-email-michaelc@cs.wisc.edu> <1337246479.30498.8.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40558 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab2EQPPm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2012 11:15:42 -0400
In-Reply-To: <1337246479.30498.8.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On 05/17/2012 04:21 AM, James Bottomley wrote:
> patching file drivers/scsi/scsi_transport_fc.c
> Hunk #2 FAILED at 2813.
> Hunk #3 FAILED at 2880.
> Hunk #4 FAILED at 3086.
> Hunk #5 succeeded at 3129 (offset 4 lines).
> 3 out of 5 hunks FAILED -- saving rejects to file
> drivers/scsi/scsi_transport_fc.c.rej
> 
> Could you rebase?
> 

Will do. My other scsi_transport_fc patch that got merged conflicted.
will fix up.
