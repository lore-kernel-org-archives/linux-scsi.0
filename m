From: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.39-rc3-git3 crashs after booting
Date: Thu, 14 Apr 2011 20:15:14 +0200
Message-ID: <20110414181514.GA13977@elte.hu>
References: <web-504663160@zbackend1.aha.ru>
 <20110414104039.c0e655bd.akpm@linux-foundation.org>
 <1302803619.9800.4.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:35133 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964858Ab1DNSPh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2011 14:15:37 -0400
Content-Disposition: inline
In-Reply-To: <1302803619.9800.4.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>, gregkh@suse.de, tj@kernel.org, randy.dunlap@oracle.com, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> +	/* temporary expedient, try to catch use of queue lock after
> +	 * free of sdev */
> +	sdev->request_queue = NULL;

Couldnt help to notice this small ugliness while skimming the patch - please 
use the customary (multi-line) comment style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

Thanks,

        Ingo
