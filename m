From: Andi Kleen <ak@muc.de>
Subject: Re: [PATCH] Add compat_ioctl to scsi host structure
Date: 19 Jan 2005 00:27:45 +0100
Message-ID: <20050118232745.GA66256@muc.de>
References: <20050118110354.GB43344@muc.de> <1106062536.5151.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:14860 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S261472AbVARX1q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 18:27:46 -0500
Date: Wed, 19 Jan 2005 00:27:45 +0100
Content-Disposition: inline
In-Reply-To: <1106062536.5151.2.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jan 18, 2005 at 07:35:36AM -0800, James Bottomley wrote:
> On Tue, 2005-01-18 at 12:03 +0100, Andi Kleen wrote:
> > Add a call vector for 32bit compat ioctls to the SCSI host
> > structure. This is needed for some followon patches.
> > 
> > Signed-off-by: Andi Kleen <ak@muc.de>
> 
> Shouldn't this also be surrounded by #ifdef CONFIG_COMPAT (on the
> grounds that you never fill it in unless CONFIG_COMPAT is defined)?

At least the standard file_operations has it without ifdef. 
I guess it doesn't hurt too much even on non compat systems.

-Andi
