From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 9/11]  lpfc 8.1.1 : Add polled-mode support
Date: Mon, 28 Nov 2005 21:02:44 -0700
Message-ID: <20051129040244.GA28049@parisc-linux.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C5F@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:6040 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750712AbVK2ECq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 23:02:46 -0500
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C5F@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org

On Mon, Nov 28, 2005 at 04:10:37PM -0500, James.Smart@Emulex.Com wrote:
> 
> > This needs some documentation for where it is useful.  Do you 
> > want this
> > to avoid interrupts under high loads or for something else? 
> 
> Yes - we've been asked to support this mode so that a heavily loaded
> system can claim back some cpu cycles spent on interrupt processing.
> (SPC benchmarks being a prime example)

sounds like we need to implement SAPI ;-)

[ for those with no clue what i'm talking about, see
Documentation/networking/NAPI_HOWTO.txt ]
