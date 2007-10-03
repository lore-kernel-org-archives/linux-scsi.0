From: Jeff Garzik <jeff@garzik.org>
Subject: Re: generating a Linux WWN?
Date: Tue, 02 Oct 2007 20:35:03 -0400
Message-ID: <4702E3B7.9060403@garzik.org>
References: <842443.13470.qm@web31811.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57790 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbXJCAfL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 20:35:11 -0400
In-Reply-To: <842443.13470.qm@web31811.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Michael Reed <mdr@sgi.com>, James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> This still does not justify "let's generate it in the kernel".

Once an admin specifies to use an alternate WWN provision, the method 
used to obtain that WWN is an implementation detail and irrelevant.

	Jeff


