From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] fusion :  VMWare guest OS remounted as read only fix
Date: Mon, 19 Mar 2007 17:07:33 +0000
Message-ID: <20070319170733.GB3611@infradead.org>
References: <20070319163150.GA28077@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46977 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966027AbXCSRHe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2007 13:07:34 -0400
Content-Disposition: inline
In-Reply-To: <20070319163150.GA28077@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Mon, Mar 19, 2007 at 10:31:51AM -0600, Eric Moore wrote:
> This address the issue of VMWare guest OS being remounted as read-only becuase the underlying device was held busy too long, , and at the same time address Engenio MPP driver concerns over infinite retries.  This patch removes the code that snoops the SAM STATUS on busy, which would be returning DID_BUS_BUSY, instead we return the status as is.   Retry hanlding seems to be properly handled in scsi_softirq_done, where a busy sam status would only occurr for the time specified by (cmd->allowed  +1) * cmd->timeout_per_command.

Looks good to me.

