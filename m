From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [stable] [PATCH 1/2] sd: fix memory corruption by	sd_read_cache_type
Date: Sun, 26 Feb 2006 17:21:29 +0100
Message-ID: <4401D589.6080204@s5r6.in-berlin.de>
References: <tkrat.014f03dc41356221@s5r6.in-berlin.de>	 <20060225021009.GV3883@sorel.sous-sol.org>	 <4400E34B.1000400@s5r6.in-berlin.de>	 <Pine.LNX.4.64.0602251600480.22647@g5.osdl.org>	 <1140930888.3279.4.camel@mulgrave.il.steeleye.com>	 <20060226053138.GM27946@ftp.linux.org.uk> <1140964451.3337.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:38889 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751335AbWBZQXK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Feb 2006 11:23:10 -0500
In-Reply-To: <1140964451.3337.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Linus Torvalds <torvalds@osdl.org>, Chris Wright <chrisw@sous-sol.org>, stable@kernel.org, Jody McIntyre <scjody@modernduck.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
...
> how about this for the actual patch (for 2.6.16) ... I put two
> more tidy ups into it ...
...
> +#define SD_BUF_SIZE		512

Thanks.
Believe it or not, I was actually about to follow up with something like 
this. :-)
-- 
Stefan Richter
-=====-=-==- --=- ==-=-
http://arcgraph.de/sr/
