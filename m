From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] libsrp: fix compile failure
Date: Wed, 30 Dec 2009 13:55:57 -0600
Message-ID: <1262202957.2749.241.camel@mulgrave.site>
References: <1262200866.2749.226.camel@mulgrave.site>
	 <alpine.LFD.2.00.0912301132260.11961@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753366AbZL3T4M@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0912301132260.11961@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefani Seibold <stefani@seibold.net>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-12-30 at 11:33 -0800, Linus Torvalds wrote:
> 
> On Wed, 30 Dec 2009, James Bottomley wrote:
> >
> > The fix is simple, just add the include, but how did this happen?  This 
> > change, introduced at -rc2, hardly looks like a bug fix, and it clearly 
> > didn't go through linux-next, which would have picked up this compile 
> > failure (it only occurs on ppc because of the ibm virtual scsi target).
> 
> It came through Andrew - and apparently parts of Andrews chain weren't in 
> next. Don't know why.
> 
> > James
> 
> Sign-off?

Sorry, forgot ... 

Signed-off-by: James Bottomley <James.Bottomley@suse.de>

James
