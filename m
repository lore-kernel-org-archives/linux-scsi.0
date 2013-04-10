From: Andy Whitcroft <apw@canonical.com>
Subject: Re: checkpatch: kill the bogus camelcase check
Date: Wed, 10 Apr 2013 14:26:28 +0100
Message-ID: <20130410132628.GV7511@dm>
References: <1365544254.2946.53.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1365544254.2946.53.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 09, 2013 at 02:50:54PM -0700, James Bottomley wrote:
> It's making checkpatch unusable on most drivers because it's spewing
> tons of bogus warnings.  The problem is the assumption that studly caps
> is always wrong: it isn't if the variables are named after the various
> conventions in the hardware programming guides (which are usually
> written by Microsoft people).
> 
> In order to encourage people to use checkpatch, it has to be *useful* it
> can't stray too far into dogmatic things like this that are essentially
> unfixable by most people who submit patches.
> 
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>

Joe, perhaps this could become a strict check?

-apw
