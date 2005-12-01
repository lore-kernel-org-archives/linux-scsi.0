From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 9/11][REPOST #2]  lpfc 8.1.1 : Add polled-mode support
Date: Thu, 01 Dec 2005 17:21:53 +0100
Message-ID: <1133454114.2853.69.camel@laptopd505.fenrus.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B85@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:10624 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932314AbVLAQV5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 11:21:57 -0500
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B85@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Thu, 2005-12-01 at 10:54 -0500, James.Smart@Emulex.Com wrote:
> 
> if value is 1 :
>   Interrupts are left enabled, expecting that the user has tuned the
>   interrupt coalescing values. When this setting is enabled, the
> driver
>   will attempt to service completed i/o whenever new i/o is submitted
>   to the adapter. If the coalescing values are large, and the i/o
>   generation rate steady, an interrupt will be avoided by servicing
>   completed i/o prior to the coalescing thresholds kicking in.
> However,
>   if the i/o completion load is high enough or i/o generation slow,
> the
>   coalescion values will ensure that completed i/o is serviced in a
> timely
>   fashion.

this sounds nice.. couldn't this be the default? (even if the delays
aren't set by default).. 

