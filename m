From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] libsrp: fix compile failure
Date: Wed, 30 Dec 2009 11:33:38 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0912301132260.11961@localhost.localdomain>
References: <1262200866.2749.226.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753297AbZL3Ted@vger.kernel.org>
In-Reply-To: <1262200866.2749.226.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Stefani Seibold <stefani@seibold.net>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On Wed, 30 Dec 2009, James Bottomley wrote:
>
> The fix is simple, just add the include, but how did this happen?  This 
> change, introduced at -rc2, hardly looks like a bug fix, and it clearly 
> didn't go through linux-next, which would have picked up this compile 
> failure (it only occurs on ppc because of the ibm virtual scsi target).

It came through Andrew - and apparently parts of Andrews chain weren't in 
next. Don't know why.

> James

Sign-off?

		Linus
