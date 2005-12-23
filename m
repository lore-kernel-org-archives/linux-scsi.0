From: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] Re: [patch 18/19] SCSI: fix transfer direction in scsi_lib and st
Date: Fri, 23 Dec 2005 15:22:19 -0800
Message-ID: <20051223232219.GA1056@sorel.sous-sol.org>
References: <20051223221200.342826000@press.kroah.org> <20051223224852.GR19057@kroah.com> <1135379125.3728.57.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:31873 "EHLO
	sorel.sous-sol.org") by vger.kernel.org with ESMTP id S1161130AbVLWXV4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 18:21:56 -0500
Content-Disposition: inline
In-Reply-To: <1135379125.3728.57.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, torvalds@osdl.org, Theodore Ts'o <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, linux-scsi@vger.kernel.org, Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, stefanr@s5r6.in-berlin.de, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org, alan@lxorguk.ukuu.org.uk

* James Bottomley (James.Bottomley@SteelEye.com) wrote:
> On Fri, 2005-12-23 at 14:48 -0800, Greg Kroah-Hartman wrote:
> > plain text document attachment
> > (scsi-fix-transfer-direction-in-scsi_lib-and-st.patch)
> > -stable review patch.  If anyone has any objections, please let us know.
> 
> Erm, on this diff, you're missing the function
> 
> scsi_setup_blk_pc_cmnd()
> 
> Unless these patches were split up strangely and it actually went
> through in some other patch that wasn't sent to linux-scsi?

It's in the prior patch (17/19).  It is split up a little differently.

thanks,
-chris
