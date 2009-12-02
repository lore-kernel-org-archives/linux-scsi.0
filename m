From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 0/3] qla2xxx: fixes for 2.6.32-rc8
Date: Wed, 02 Dec 2009 15:04:20 -0500
Message-ID: <1259784260.5430.136.camel@mulgrave.site>
References: <1259779016-1762-1-git-send-email-giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbZLBUEV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2009 15:04:21 -0500
In-Reply-To: <1259779016-1762-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: giridhar.malavali@qlogic.com
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Wed, 2009-12-02 at 10:36 -0800, giridhar.malavali@qlogic.com wrote:
> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
> 
> Please apply...
> 
> Anirban Chakraborty (1):
>   Fix to accommodate a hardware bug in multiqueue mode that does not
>     work properly when acknowledgement of MSIX Interrupts is disabled.

OK, so this looks like a bug fix

> Giridhar Malavali (2):
>   qla2xxx: Queue depth ramp up/down modification changes.

But this looks like an enhancement

Which tree did you want these in?  scsi-misc is fine ... if you want
them in rc-fixes, I need the enhancement removed.

Thanks,

James


