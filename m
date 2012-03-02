From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 5/7] scsi: Add a report opcode helper
Date: Thu, 01 Mar 2012 23:08:44 -0500
Message-ID: <4F5047CC.2080002@garzik.org>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com> <1330658571-12958-6-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64801 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab2CBEIu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 23:08:50 -0500
Received: by vbbff1 with SMTP id ff1so1163672vbb.19
        for <linux-scsi@vger.kernel.org>; Thu, 01 Mar 2012 20:08:49 -0800 (PST)
In-Reply-To: <1330658571-12958-6-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, vgoyal@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On 03/01/2012 10:22 PM, Martin K. Petersen wrote:
> From: "Martin K. Petersen"<martin.petersen@oracle.com>
>
> The REPORT SUPPORTED OPERATION CODES command can be used to query
> whether a given opcode is supported by a device. Add a helper function
> that allows us to look up commands.
>
> We only issue RSOC if the device reports compliance with SPC-3 or
> later. But to err on the side of caution we disable the command for ATA,
> FireWire and USB.
>
> Signed-off-by: Martin K. Petersen<martin.petersen@oracle.com>
> Acked-by: Mike Snitzer<snitzer@redhat.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>

(though implementing RSOC in simulator for ATA is still desired, as that 
placeholder will be used in the future)



