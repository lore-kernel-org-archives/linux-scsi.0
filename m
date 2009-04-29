From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi: ses check name in enclosure_component_register
Date: Wed, 29 Apr 2009 05:08:47 -0600
Message-ID: <20090429110846.GG21648@parisc-linux.org>
References: <49F6678D.3080207@kernel.org> <1240957589.3380.67.camel@mulgrave.int.hansenpartnership.com> <49F7979A.8040302@kernel.org> <1240964289.3380.73.camel@mulgrave.int.hansenpartnership.com> <49F7A71F.5040709@kernel.org> <20090429020331.GF21648@parisc-linux.org> <49F7CA9A.5000701@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760386AbZD2LJL@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49F7CA9A.5000701@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 28, 2009 at 08:33:46PM -0700, Yinghai Lu wrote:
> Matthew Wilcox wrote:
> > On Tue, Apr 28, 2009 at 06:02:23PM -0700, Yinghai Lu wrote:
> >> dev_set_name(cdev, name);
> >>
> >> the name become fmt. 
> > 
> > Yes, and what happens if 'name' is '%s'?
> > 
> 
> change
> dev_set_name(cdev, name);
> to
> dev_set_name(cdev, "%s", name);
> 
> didn't fix the problem.
> 
> need to check name && name[0]

Yes.  There are _two_ problems.  You fixed one.  James asked if you
would fix the other while you're touching that code.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
