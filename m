From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Correct some mistakes in drivers using the scsi hotplug
 model
Date: Tue, 31 Jul 2007 09:27:24 -0400
Message-ID: <46AF38BC.8090703@garzik.org>
References: <20070731125510.GN21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:36834 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757154AbXGaN10 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jul 2007 09:27:26 -0400
In-Reply-To: <20070731125510.GN21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> A few drivers are doing things like releasing IRQs before calling
> scsi_remove_host(), which can lead to some ugly error messages.
> Many more drivers are simply forgetting to call scsi_host_put() after
> they've finished tearing down their driver structures.
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>

ACK

BTW a diffstat with patches that touch more than one file are useful


