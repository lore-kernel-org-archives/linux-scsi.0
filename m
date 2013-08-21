From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [TRIVIAL] Remove braces in drivers/scsi/in2000.h to fix
 build for clang. No functional change otherwise.
Date: Tue, 20 Aug 2013 23:50:18 -0700
Message-ID: <20130821065018.GB9043@infradead.org>
References: <1377033546-19475-1-git-send-email-dl9pf@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1377033546-19475-1-git-send-email-dl9pf@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: dl9pf@gmx.de
Cc: PaX Team <pageexec@freemail.hu>, Behan Webster <behanw@converseincode.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 20, 2013 at 11:19:06PM +0200, dl9pf@gmx.de wrote:
> From: Jan-Simon M??ller <dl9pf@gmx.de>
> 
> Author:  PaX Team <pageexec at freemail.hu>
> ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
> URL:     http://llvm.linuxfoundation.org
> 
> Merge:   Jan-Simon M??ller <dl9pf at gmx.de>
> 
> Description:
>   Clang chokes on the notation "insw (%%dx)" but works for "insw %%dx" (outsw likewise);
>   GNU as accepts both forms.
> 
> Signed-off-by: Jan-Simon M??ller <dl9pf@gmx.de>

I think the right fix is to simply kill the FAST_READ_IO/FAST_WRITE_IO
defines and their associated inline assembly entirely.
