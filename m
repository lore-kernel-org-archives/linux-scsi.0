From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 68/77] ncr5380: Fix whitespace issues using regexp
Date: Tue, 22 Dec 2015 17:22:29 -0800
Message-ID: <1450833749.2381.27.camel@HansenPartnership.com>
References: <20151222011737.980475848@telegraphics.com.au>
	  <20151222011756.506380156@telegraphics.com.au>
	 <1450795615.21677.10.camel@perches.com>
	 <alpine.LNX.2.00.1512231138330.28866@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1512231138330.28866@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Joe Perches <joe@perches.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-12-23 at 11:56 +1100, Finn Thain wrote:
> On Tue, 22 Dec 2015, Joe Perches wrote:
> 
> > On Tue, 2015-12-22 at 12:18 +1100, Finn Thain wrote:
> > > This patch is just the result of two substitutions. The first
> removes 
> > > any tabs and spaces at the end of the line. The second replaces
> runs 
> > > of tabs and spaces at the beginning of comment lines with a
> single 
> > > space.
> > 
> > I think the second of these isn't done well.
> 
> The aim of this patch is not to fix code style, but to make it 
> possible to compare these two files so that the fork can be repaired. 
> Regexp is very helpful in creating uniformity (and a minimal diff).
> 
> If this was a coding style issue, we would be discussing the use of 
> kernel-doc format for the affected comments, not whitespace.
> 
> > Many of these comments post reformatting are
> > much worse to read because of lost alignment.
> 
> You exaggerate a very trivial point.
> 
> I admit that a small proportion of comments are slightly less 
> readable. But it is the diff that needs to be readable in order to 
> resolve the fork.
> 
> As I said in patch 0, I am aware that this patch series can be 
> faulted on trivial grounds but in order to avoid churn I don't wish 
> to address those issues until the fork has been resolved.

I don't think it is trivial.  I can't actually find a single instance
in this patch where collapsing the space at the start of the comment
looks justified; most of the time it eliminates intended formatting.
Even if there's an odd one I've missed where space at the beginning of
a comment is a problem, I think not doing that part of the regexp and
just correcting the odd missed case by hand later will be much better.

James
