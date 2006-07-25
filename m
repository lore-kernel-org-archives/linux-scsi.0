From: hch <hch@infradead.org>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Tue, 25 Jul 2006 10:26:56 +0100
Message-ID: <20060725092656.GA28195@infradead.org>
References: <NONAMEBFJ3sl3xbYiMC000000d4@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:20122 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751526AbWGYJ1F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jul 2006 05:27:05 -0400
Content-Disposition: inline
In-Reply-To: <NONAMEBFJ3sl3xbYiMC000000d4@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "James.Bottomley" <James.Bottomley@SteelEye.com>, hch <hch@infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>, promise_linux <promise_linux@promise.com>, jeff <jeff@garzik.org>

On Tue, Jul 25, 2006 at 12:41:11PM +0800, Ed Lin wrote:
> 
> So it seems there are several possibilities here(regarding no.1 comment):
> 1.The bridge code is kept unchanged. And, as this is a violation to
> Linux tradition and requirement, it could not be admitted upstream.

We have more than enough precedence for poking the bridge that comes as
part of addon cards.  As long as the code makes sure it never pokes a bridge
of the same type that is not on the card (and I don't have the code in front
of me right now to check whether it's true) we can keep this code.  Please
make sure to add a big comment that explains what is going on in detail
and why it's okay in this special case.

