From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 06/21] advansys: Remove ASC_SELECT_QUEUE_DEPTHS
Date: Tue, 02 Oct 2007 22:17:24 -0400
Message-ID: <4702FBB4.3080407@garzik.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765422891-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:37450 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbXJCCRZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 22:17:25 -0400
In-Reply-To: <11913765422891-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> It was only ever set; never tested, nor cleared.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/scsi/advansys.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)

ACK


