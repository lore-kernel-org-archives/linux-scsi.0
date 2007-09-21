From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libata: slightly improved req-sense, send-diag no-ops
Date: Fri, 21 Sep 2007 07:12:59 -0400
Message-ID: <46F3A73B.9040309@garzik.org>
References: <20070921102424.GA17675@havoc.gtf.org> <20070921121717.16c7dcf1@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:52012 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462AbXIULNF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Sep 2007 07:13:05 -0400
In-Reply-To: <20070921121717.16c7dcf1@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Alan Cox wrote:
>>     REQUEST SENSE -- as we autosense, R.S. just returns zeroes
>>     
>>     SEND DIAGNOSTIC -- our default (no-op) self-test succeeds, all
>>     		   other requests for testing fail.
>>     
>>     Signed-off-by: Jeff Garzik <jeff@garzik.org>
> 
> Acked-by: Alan Cox <alan@redhat.com>
> 
> Possibly our default SEND_DIAGNOSTIC should turn into smart or just
> return whether the drive failed the power up diagnostic ?

Either/or.  In general the SAT (SCSI/ATA translation) spec posted 
publicly on http://www.t10.org/ gives the suggested transformation into 
ATA commands.  And yep, you guessed it -- send diag morphs into SMART.

I doubt I'm motivated enough to enhance send diag, but others are 
encouraged to do so.

	Jeff



