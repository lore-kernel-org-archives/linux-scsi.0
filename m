From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI: Replace semaphores with wait_even
Date: 24 Oct 2004 15:57:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098647869.10824.247.camel@mulgrave>
References: <1098300579.20821.65.camel@thomas>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:40162 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261241AbUJXT6A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 15:58:00 -0400
In-Reply-To: <1098300579.20821.65.camel@thomas>
List-Id: linux-scsi@vger.kernel.org
To: tglx@linutronix.de
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-10-20 at 15:29, Thomas Gleixner wrote:
> 
> Use wait_event instead of semaphores. Semaphores are slower
> and trigger owner conflicts during semaphore debugging.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Ingo Molnar <mingo@elte.hu>
> ---

There's something deeply wrong with this.  It causes a boot hang in my
scsi test systems.

James


