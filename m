From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [LSF/MM TOPIC] SCSI referrals support
Date: Thu, 20 Jan 2011 17:14:33 +0100
Message-ID: <4D385F69.5060209@interlog.com>
References: <4D385C0A.3000901@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:39367 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab1ATQOg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2011 11:14:36 -0500
In-Reply-To: <4D385C0A.3000901@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On 11-01-20 05:00 PM, Hannes Reinecke wrote:
> Agenda topic proposal:
>
> SCSI referrals support has already been discussed at last year's LSF
> conference. However, the solution proposed there would not support
> failover and would require quite a lot of changes to multipathing.
>
> To enable failover it might be an idea to handle the LUN directly in
> multipathing. This would require eg:
> - request splitting
> - I/O alignment handling
> - SCSI unit attention handling
>
> I would be giving a short overview/presentation of the current
> state of the art, the shortcomings on the original proposal,
> and would like to invite a discussion on how to best support
> SCSI referrals.

IMO a worrying aspect of the changes associated with SCSI
referrals is that sense data can now be returned with any
SCSI status (i.e. not just CHECK CONDITION). How well would
the SCSI subsystem cope with that? I know that the sg driver
(and probably bsg) would need changes, as would my libsgutils
library used by sg3_utils.

Doug Gilbert

