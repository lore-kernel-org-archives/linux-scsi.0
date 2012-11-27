From: Ewan Milne <emilne@redhat.com>
Subject: Re: Error handling on FC devices
Date: Tue, 27 Nov 2012 15:03:21 -0500
Message-ID: <1354046601.4420.14.camel@localhost.localdomain>
References: <50AA290F.8000105@suse.de>  <50B3EDEA.40008@emulex.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab2K0UEI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Nov 2012 15:04:08 -0500
In-Reply-To: <50B3EDEA.40008@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@emulex.com
Cc: Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Mon, 2012-11-26 at 17:32 -0500, James Smart wrote:
> Given path switching is somewhat separate from the i/o, would it better 
> to send a notification of a path-fail condition as part of the eh, 
> rather than hinging it on the individual i/o.  Yes, the i/o is still in 
> limbo and can't be switched to the new path, but other i/o could without 
> incurring the delay.

Is there a potential issue with a write that is taking a long time on
one path, which could cause path switching for subsequent writes to
another path, before the disposition of the first write is known?


