From: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] [PATCH 1/2] sd: fix memory corruption by sd_read_cache_type
Date: Fri, 24 Feb 2006 18:10:09 -0800
Message-ID: <20060225021009.GV3883@sorel.sous-sol.org>
References: <tkrat.014f03dc41356221@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:37507 "EHLO
	sorel.sous-sol.org") by vger.kernel.org with ESMTP id S964850AbWBYCIC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Feb 2006 21:08:02 -0500
Content-Disposition: inline
In-Reply-To: <tkrat.014f03dc41356221@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: stable@kernel.org, Linus Torvalds <torvalds@osdl.org>, Jody McIntyre <scjody@modernduck.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>

* Stefan Richter (stefanr@s5r6.in-berlin.de) wrote:
> sd: fix memory corruption by sd_read_cache_type

Looks like these still aren't upstream.  Can you please resend to -stable
once they've been picked up by Linus?

thanks,
-chris
