From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/11]  lpfc 8.1.1 : Fixes to error handlers
Date: Mon, 28 Nov 2005 19:27:45 +0000
Message-ID: <20051128192745.GA25568@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C56@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36006 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932198AbVK1T1v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 14:27:51 -0500
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C56@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: stefanr@s5r6.in-berlin.de, linux-scsi@vger.kernel.org

On Mon, Nov 28, 2005 at 02:08:56PM -0500, James.Smart@Emulex.Com wrote:
> This is true - when invoked via the error handler thread.  Unfortunately,
> reset functions invoked via SG do not have the same behavior. There is a
> rather large test suite from a big storage vendor that uses asynchronous
> resets via SG extensively.

So you this storage vendor please provide us this test case as a start?

That beeing said I mentioned that we need to do SG-based resets via the
EH thread aswell.  As Emulex apparently cares about the above case would
you mind implementing it?

