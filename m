From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/11]  lpfc 8.1.1 : Fixes to error handlers
Date: Wed, 30 Nov 2005 19:16:43 +0000
Message-ID: <20051130191643.GB19164@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B76@xbl3.emulex.com> <438BFF2E.20407@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:21698 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751505AbVK3TQx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 14:16:53 -0500
Content-Disposition: inline
In-Reply-To: <438BFF2E.20407@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James.Smart@Emulex.Com, hch@infradead.org, stefanr@s5r6.in-berlin.de, linux-scsi@vger.kernel.org

On Tue, Nov 29, 2005 at 05:11:42PM +1000, Douglas Gilbert wrote:
> While on the subject of resets, linux still has a
> fuzziness around a "device" reset. There should be
> two resets around this level:
>   - target reset: reset a target device, its ports and
>     all logical units within it [transport level]
>   - logical unit reset: reset a logical unit only
>     [this is a mandatory SCSI task management function]

Agreed.  In fact the emulex driver has a target reset handler already
in lower level code, but only loops over it for all found targets in the
linux bus reset handler.

> If changes are being made in this area, then perhaps
> this fuzziness should be addressed.

I don't think it's related to the asynchronous reset change.  On the
other hand it's a pretty simple change, I should have done it long
ago.

