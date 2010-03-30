From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_debug: add max_queue + no_uld parameters
Date: Tue, 30 Mar 2010 13:30:41 -0400
Message-ID: <yq18w99emym.fsf@sermon.lab.mkp.net>
References: <4BABD5A1.4050003@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:52864 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab0C3Rct (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2010 13:32:49 -0400
In-Reply-To: <4BABD5A1.4050003@interlog.com> (Douglas Gilbert's message of
	"Thu, 25 Mar 2010 17:29:05 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: James Bottomley <James.Bottomley@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> While testing the midlevel q_at_head and q_at_tail patch for sg
Doug> and the block SG_IO ioctl I found it useful to reduce the queuing
Doug> within the scsi_debug driver. The reason is that the midlevel
Doug> queue only comes into play when the corresponding LLD queue is
Doug> full.

Doug> It is also useful when testing to be confident that your program
Doug> is the only thing issuing commands to the (virtual) scsi_debug
Doug> device. The no_uld=1 parameter will stop a scsi_debug virtual disk
Doug> appearing as /dev/sd* .

Doug> Changelog:
Doug>   - add max_queue parameter to reduce the number
Doug>     of queued commands the driver will accept.  This parameter can
Doug>     be changed after the driver is loaded.
Doug>   - add no_uld parameter that restricts scsi_debug's
Doug>     virtual devices to the sg and bsg drivers
Doug>   - correct stale url

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
