From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Fri, 10 May 2013 08:43:11 -0400
Message-ID: <1368189791.3319.31.camel@localhost.localdomain>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab3EJMnr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 May 2013 08:43:47 -0400
In-Reply-To: <yq1fvxvedg6.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, michaelc@cs.wisc.edu

On Thu, 2013-05-09 at 23:11 -0400, Martin K. Petersen wrote:
> Introduce eh_timeout which can be used for error handling purposes. This
> was previously hardcoded to 10 seconds in the SCSI error handling
> code. However, for some fast-fail scenarios it is necessary to be able
> to tune this as it can take several iterations (bus device, target, bus,
> controller) before we give up.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 

Thanks for posting this.  It will be very helpful to have this
capability, particularly when alternate paths to the device exist.

Acked-by: Ewan D. Milne <emilne@redhat.com>


