From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [stable] [PATCH 1/2] sd: fix memory corruption by sd_read_cache_type
Date: Sun, 26 Feb 2006 00:17:16 +0000
Message-ID: <20060226001716.GL27946@ftp.linux.org.uk>
References: <tkrat.014f03dc41356221@s5r6.in-berlin.de> <20060225021009.GV3883@sorel.sous-sol.org> <4400E34B.1000400@s5r6.in-berlin.de> <Pine.LNX.4.64.0602251600480.22647@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750740AbWBZAR3@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0602251600480.22647@g5.osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Chris Wright <chrisw@sous-sol.org>, stable@kernel.org, Jody McIntyre <scjody@modernduck.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 25, 2006 at 04:01:35PM -0800, Linus Torvalds wrote:
> 
> 
> On Sun, 26 Feb 2006, Stefan Richter wrote:
> 
> > Chris Wright wrote:
> > > * Stefan Richter (stefanr@s5r6.in-berlin.de) wrote:
> > > > sd: fix memory corruption by sd_read_cache_type
> > > 
> > > Looks like these still aren't upstream.  Can you please resend to -stable
> > > once they've been picked up by Linus?
> > 
> > Yes, I will do so.
> 
> Perhaps equally importantly, let's get them into mainline if they are so 
> important. Which means that I want sign-offs and acks from the appropriate 
> people (scsi and original author, which is apparently Al).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

FWIW, there's a potential problem: original was not split in two, and AFAICS
it was picked by SCSI folks in that form.  I've no objections against
such split, just wondering if git might...

ObGit: is there any way to fetch _all_ branches from remote, creating local
branches with the same names if they didn't exist yet?  Ot, at least, get
the full list of branches existing in the remote repository...
