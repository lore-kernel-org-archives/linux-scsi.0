From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 17/21] advansys: remove detect_called
Date: Thu, 26 Jul 2007 15:48:06 -0400
Message-ID: <46A8FA76.7050603@garzik.org>
References: 20070726171141.GE19275@parisc-linux.org <1185470577234-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50994 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbXGZTsI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 15:48:08 -0400
In-Reply-To: <1185470577234-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> Apparently it used to be possible to call the detect method twice.

Perhaps in pre-history, but not in today's kernel...

The patch is nonetheless correct, of course...

	Jeff



