From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] SCSI fixes for 3.18-rc4
Date: Wed, 19 Nov 2014 22:43:11 -0800
Message-ID: <20141120064311.GB29412@infradead.org>
References: <1416154652.22472.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1416154652.22472.5.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 16, 2014 at 08:17:32AM -0800, James Bottomley wrote:
> This is a set of six fixes and a MAINTAINER update. The fixes are two
> multipath (one in Test Unit Ready handling for the path checkers and one
> in the section of code that sends a start unit after failover; both of
> these were perturbed by the scsi-mq update), a CD-ROM door locking fix
> that was likewise introduced by scsi-mq and three driver fixes for a
> previous code update in cxgb4i, megaraid_sas and bnx2fc.

FYI, the multipath issue actually is due much older EH changes, not due
to blk-mq work.
