From: Daniel Walker <dwalker@fifo99.com>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
Date: Fri, 09 Oct 2009 06:10:10 -0700
Message-ID: <1255093810.18167.398.camel@desktop>
References: <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain>
	 <1254862442.4383.183.camel@mulgrave.site>
	 <1255012399.4187.24.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain>
	 <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain>
	 <1255031298.4187.260.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910081252090.3432@localhost.localdomain>
	 <alpine.LFD.2.01.0910081255510.3432@localhost.localdomain>
	 <20091008210737.GD29181@mit.edu>
	 <alpine.LFD.2.01.0910081410400.3432@localhost.localdomain>
	 <20091009091538.GA4154@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fifo99.com ([67.223.236.141]:44052 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbZJINLj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Oct 2009 09:11:39 -0400
In-Reply-To: <20091009091538.GA4154@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jing Huang <huangj@brocade.com>

On Fri, 2009-10-09 at 11:15 +0200, Ingo Molnar wrote:
> 
> I dont know what's the current mainline inclusion quality threshold for 
> non-staging Linux drivers - it might be ok. Also, the driver commit has 
> been rebased a few days ago which makes it hard to see its stability 
> track record.
> 
> 	Ingo
> 
> --------------->
> ERROR: return is not a function, parentheses are not required
> #191: FILE: fcbuild.c:191:
> +			return (FC_PARSE_BUSY);

The author submitted a basic style clean up here,

http://patchwork.kernel.org/patch/50161/

It was a series that did the whole driver.. I'm not sure why those
patches aren't included, but at least there was an attempt at cleaning
the driver up..

Daniel

