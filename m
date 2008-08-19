From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 3/6] qla2xxx: return SCSI_MLQUEUE_TARGET_BUSY when
	driver has detected rport error or race
Date: Tue, 19 Aug 2008 09:16:49 -0700
Message-ID: <20080819161649.GL12709@plap4-2.qlogic.org>
References: <1219004683-6468-1-git-send-email-michaelc@cs.wisc.edu> <1219004683-6468-2-git-send-email-michaelc@cs.wisc.edu> <1219004683-6468-3-git-send-email-michaelc@cs.wisc.edu> <1219004683-6468-4-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:1075 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbYHSQQu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2008 12:16:50 -0400
Content-Disposition: inline
In-Reply-To: <1219004683-6468-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Sun, 17 Aug 2008, michaelc@cs.wisc.edu wrote:

> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> If the fcport is not online then we do not want to block IO to all ports on
> the host. We just want to stop IO on port not online, so we should be using
> the SCSI_MLQUEUE_TARGET_BUSY return value.
> 
> For the case where we race with the rport memset initialization
> we do not want the queuecommand to be called again so we can just use
> SCSI_MLQUEUE_TARGET_BUSY for this.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
