From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BK-PATCH] 3w-9xxx: proc interface
Date: Fri, 2 Jul 2004 19:35:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040702183506.GA30810@infradead.org>
References: <Pine.GSO.4.33.0407021202290.25702-200000@sweetums.bluetronic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:27836 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S264857AbUGBSfM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jul 2004 14:35:12 -0400
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.33.0407021202290.25702-200000@sweetums.bluetronic.net>
List-Id: linux-scsi@vger.kernel.org
To: Ricky Beam <jfbeam@bluetronic.net>
Cc: Adam Radford <aradford@amcc.com>, Linux SCSI List <linux-scsi@vger.kernel.org>

On Fri, Jul 02, 2004 at 12:08:23PM -0400, Ricky Beam wrote:
> 3dm2 (the currently available one anyway) needs /proc/scsi/3w-9xxx to
> discover any controllers.  The current in-kernel driver doesn't contain any
> /proc/scsi support.  The attached patch restores the interface.

I'd rather wait for a new 3dm2 release instead of adding deprecated interfaces.
Adam, any schedule for a new release?
