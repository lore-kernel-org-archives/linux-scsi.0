From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: aacraid driver question
Date: Mon, 25 Aug 2003 20:41:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825204111.A11089@infradead.org>
References: <0998F43EAD645A47B3F6507196DD70EA2568CB@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:41476 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262186AbTHYTlO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 15:41:14 -0400
Content-Disposition: inline
In-Reply-To: <0998F43EAD645A47B3F6507196DD70EA2568CB@OTCEXC01>; from mark_salyzyn@adaptec.com on Mon, Aug 25, 2003 at 03:32:32PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: 'Mark Haverkamp' <markh@osdl.org>, linux-scsi@vger.kernel.org

On Mon, Aug 25, 2003 at 03:32:32PM -0400, Salyzyn, Mark wrote:
> Your assessment at the bottom is mainly correct, the AifEnContainerChange
> can mean more than just online/offline, it also include when an array has
> completed a clear operation so that the partition table needs to be reread
> (and thus updated). I have yet to work out the mechanism to detect the
> difference of online/offline/clear to mitigate the calls. I would expect
> that scsi_rescan_device will work in the interim?

No, scsi_rescan_device won't work of bringing a new device online or
an old one offline.  It's just when attributes on an existing device
change.  So to get this sorted out nicely we'd really need to know
whether AifEnContainerChange means online/offline/clear.  BTW, why/how
does the hardware interact with partitioning on aacraid?

And what's the exact meaning of AifDenMorphComplete?  Is there some
hardware documentation on adaptec's website?

