From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 10/21] advansys: Remove asc_board_t typedef and ASC_BOARDP
 macro
Date: Tue, 02 Oct 2007 22:02:38 -0400
Message-ID: <4702F83E.1020607@garzik.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765423231-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:54723 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614AbXJCCCk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 22:02:40 -0400
In-Reply-To: <11913765423231-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> asc_board_t was simply a typedef for struct asc_board.  ASC_BOARDP()
> can be replaced by shost_priv() except in the ASC_STATS* macros which
> rely on the cast; add an explicit cast there.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

ACK


