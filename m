From: Ingo Molnar <mingo@elte.hu>
Subject: Re: scsi: aic7xxx hang since v2.6.28-rc1 ...
Date: Wed, 18 Feb 2009 16:58:17 +0100
Message-ID: <20090218155817.GC23989@elte.hu>
References: <20090215115823.GB19464@elte.hu> <Pine.LNX.4.44L0.0902171507370.18399-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:58125 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693AbZBRP6n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2009 10:58:43 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0902171507370.18399-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org


* Alan Stern <stern@rowland.harvard.edu> wrote:

> I have no idea if this will make any difference for the 
> problem you're seeing, but it has been submitted and it's 
> worth trying out.  If the problem still occurs, I'll write a 
> diagnostic patch to add log messages giving the destiny of 
> each request in scsi_io_completion().

OK, i've undone the reverts and have applied your fix - it will 
take a few hours to see whether the hang still occurs.

	Ingo
