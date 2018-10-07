From: Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.19-rc5
Date: Sun, 7 Oct 2018 07:21:52 +0200
Message-ID: <20181007052152.GB9243@kroah.com>
References: <1538846412.4088.1.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1538846412.4088.1.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 06, 2018 at 10:20:12AM -0700, James Bottomley wrote:
> Small fix for an unititialized mutex in the qedi driver.
> 
> The patch is available here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

Now merged, thanks.

greg k-h
