From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] QStor SATA/RAID v.96 for 2.6.9-rc2
Date: Tue, 21 Sep 2004 14:21:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4150712F.3080504@pobox.com>
References: <4150666A.90807@rtr.ca> <41506BBE.2050507@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:34247 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267943AbUIUSVs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 14:21:48 -0400
In-Reply-To: <41506BBE.2050507@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Mark Lord wrote:
> Okay, I missed one thing in the proof read.. these two lines (below)
> will be added to qstor.c, for use by the separate RAID management module.
> 
>    EXPORT_SYMBOL(qs_del_raid);
>    EXPORT_SYMBOL(qs_setup_raid);


Where is this seperate RAID management module?  :)

Typically we do not add kernel hooks to non-public stuff...

	Jeff


