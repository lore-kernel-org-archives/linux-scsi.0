From: Christoph Hellwig <hch@infradead.org>
Subject: Re: drop scsi_register_blocked_host() in 2.5?
Date: Fri, 21 Feb 2003 19:58:54 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030221195854.A6458@infradead.org>
References: <3E557FD5.5080708@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E557FD5.5080708@torque.net>; from dougg@torque.net on Fri, Feb 21, 2003 at 12:24:37PM +1100
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Fri, Feb 21, 2003 at 12:24:37PM +1100, Douglas Gilbert wrote:
> Just doing some documentation and noticed these two functions:
>    - scsi_register_blocked_host()
>    - scsi_deregister_blocked_host()
> that return void and do nothing. See scsi_lib.c around line 1344
> for Eric's comment. These functions are exported and the
> eata and u14-34f drivers call them.
> 
> Time for Christoph's razor?

Well, it's not used for ages and there's not much reason to keep it
around.  So this gets my vote.

