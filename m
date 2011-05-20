From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] First round of SCSI updates for 2.6.39 merge window
Date: Fri, 20 May 2011 09:01:27 -0400
Message-ID: <20110520130127.GA3428@infradead.org>
References: <1305888118.2571.5.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1305888118.2571.5.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, May 20, 2011 at 02:41:58PM +0400, James Bottomley wrote:
> new fc module for the in-kernel target infrastructure and final removal
> of the SCSI serial number, which served only to bounce lock cache lines
> in the critical path.

It's actually not completely gone yet, but we're one step closer now.
