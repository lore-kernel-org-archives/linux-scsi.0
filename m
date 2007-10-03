From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 02/21] advansys: Remove array of scsi targets
Date: Tue, 02 Oct 2007 22:19:11 -0400
Message-ID: <4702FC1F.6080607@garzik.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765422432-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55918 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbXJCCTM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 22:19:12 -0400
In-Reply-To: <11913765422432-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> The driver was saving a scsi_device for each target, but wasn't doing
> anything useful with them.  Just delete the array.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

ACK


