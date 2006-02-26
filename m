From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [stable] [PATCH 1/2] sd: fix memory corruption by sd_read_cache_type
Date: Sun, 26 Feb 2006 03:39:50 -0500
Message-ID: <44016956.2030609@pobox.com>
References: <tkrat.014f03dc41356221@s5r6.in-berlin.de> <20060225021009.GV3883@sorel.sous-sol.org> <4400E34B.1000400@s5r6.in-berlin.de> <Pine.LNX.4.64.0602251600480.22647@g5.osdl.org> <20060226001716.GL27946@ftp.linux.org.uk> <Pine.LNX.4.64.0602251626280.22647@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751274AbWBZIkV@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0602251626280.22647@g5.osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Chris Wright <chrisw@sous-sol.org>, stable@kernel.org, Jody McIntyre <scjody@modernduck.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sun, 26 Feb 2006, Al Viro wrote:
> 
>>ObGit: is there any way to fetch _all_ branches from remote, creating local
>>branches with the same names if they didn't exist yet?  Ot, at least, get
>>the full list of branches existing in the remote repository...
> 
> 
> The magic is "git-ls-remote". In particular, the "--heads" flag limits it 
> to just showing branch heads.
> 
> Then you can feed that into "git fetch", which takes the format 
> "localname:remotename" to tell it how to fetch.
> 
> In other words, something like
> 
> 	git fetch remote $(git ls-remote --heads remote | awk '{print $2":"$2}')
> 
> should do what you asked for.

Any chance we could get 'git fetch --heads' ?

FWIW, I regularly blow away and create new heads, so the above is rather 
long for people who use my repos.  A lot of them use rsync because when 
you're tracking a repo with ever-changing branches, 'git pull' doesn't 
really approximate "make local X look like remote X".

	Jeff
