From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Announce] Emulex lpfcdriver v8.0.9 available
Date: Mon, 16 Aug 2004 21:27:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040816212706.A14780@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C02F164@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:38405 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267941AbUHPU1O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 16:27:14 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F164@xbl3.ma.emulex.com>; from James.Smart@Emulex.Com on Mon, Aug 16, 2004 at 04:07:51PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Mon, Aug 16, 2004 at 04:07:51PM -0400, James.Smart@Emulex.Com wrote:
> - Removed lun handling. Removed code that replicated midlayer functions, issued report luns, did partial VSA, had unnecessary data structures, etc.

this looks very good.

> - Reworked the clock/timer handling per Christoph's comments.

Nope.  Rezad the statements about timer_pending() and mod_timer() in
my mail again.

> - Reworked driver parameters per Christoph's comments.

No really.

> To date, the known todos are:
> - Use mid-layer I/O timers
> - No Peeking into timer structures
> - Need to get approvals on all the clock changes, parameter changes, etc.
> - Add calls to scan functions on new device detection, remove_device on device loss.
> - Add interfaces to support managability.


 - streamline I/O submission path
 - sort out memory allocation issues

