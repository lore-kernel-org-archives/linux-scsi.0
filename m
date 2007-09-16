From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] set supported_mode for lots of llds
Date: Sat, 15 Sep 2007 23:07:10 -0400
Message-ID: <46EC9DDE.2090102@garzik.org>
References: <20070914223247M.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:46445 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbXIPDHP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Sep 2007 23:07:15 -0400
In-Reply-To: <20070914223247M.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
> The majority of llds don't set supported_mode in scsi_host_template so
> we get:
> 
> luce:/sys/class/scsi_host/host0$ cat supported_mode
> unknown
> 
> It's harmless but it would be better to get:
> 
> luce:/sys/class/scsi_host/host0$ cat supported_mode
> Initiator

Given that this is the /vast/ majority, just set it once as a default 
value, and let target drivers change the mode if different.

	Jeff



