From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Export ata_scsi_simulate() for use by non-libata drivers
Date: Thu, 14 Oct 2004 13:04:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416EB1B6.5070603@pobox.com>
References: <4161A06D.8010601@rtr.ca> <4165B233.9080405@rtr.ca> <416D8A4E.5030106@pobox.com> <416DA951.2090104@rtr.ca> <416DAF1A.2040204@pobox.com> <416DB912.7040805@rtr.ca> <416DBC96.2090602@pobox.com> <416EA996.4040402@rtr.ca> <416EAECC.7070000@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:52096 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266467AbUJNRFL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 13:05:11 -0400
In-Reply-To: <416EAECC.7070000@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>

Mark Lord wrote:
> +void ata_scsi_simulate(u16 *id,
> +		      struct scsi_cmnd *cmd,
> +		      void (*done)(struct scsi_cmnd *));

That you are defining a public function in multiple files should be a 
hint that something is still missing...  :)  Put a prototype in 
linux/libata.h just like the other public functions, and the patch will 
be OK.

	Jeff


