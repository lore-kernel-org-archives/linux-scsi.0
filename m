From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Export ata_scsi_simulate() for use by non-libata drivers
Date: Fri, 15 Oct 2004 01:04:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416F5A72.9080602@pobox.com>
References: <4161A06D.8010601@rtr.ca> <4165B233.9080405@rtr.ca> <416D8A4E.5030106@pobox.com> <416DA951.2090104@rtr.ca> <416DAF1A.2040204@pobox.com> <416DB912.7040805@rtr.ca> <416DBC96.2090602@pobox.com> <416EA996.4040402@rtr.ca> <416EAECC.7070000@rtr.ca> <416EB1B6.5070603@pobox.com> <416EC90A.30607@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:10210 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266250AbUJOFFE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2004 01:05:04 -0400
In-Reply-To: <416EC90A.30607@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>

Mark Lord wrote:
>  >Put a prototype in linux/libata.h
> 
> Done.  Updated patch attached.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>


applied, but, you forgot rule #6:
http://linux.yyz.us/patch-format.html

Specifically, include the full description in each patch resend.  Patch 
merging is largely automated by scripts these days, and failing to 
provide an adequate description means manual intervention is required.

The full body of your email is pasted into the BitKeeper changeset 
description.

	Jeff


