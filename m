From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 17/29] Fix the reproducible oops in scsi
Date: Wed, 7 Mar 2007 23:39:52 -0800
Message-ID: <20070307233952.8f4387de.akpm@linux-foundation.org>
References: <200703061046.l26AkgOX020036@shell0.pdx.osdl.net>
	<45ED7250.8080704@emulex.com>
	<20070306134610.d1cf9e48.akpm@linux-foundation.org>
	<1173219909.3379.50.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55576 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932960AbXCHHkF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Mar 2007 02:40:05 -0500
In-Reply-To: <1173219909.3379.50.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: James.Smart@Emulex.Com, hirofumi@mail.parknet.co.jp, hare@suse.de, linux-scsi@vger.kernel.org

> On Tue, 06 Mar 2007 16:25:09 -0600 James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Tue, 2007-03-06 at 13:46 -0800, Andrew Morton wrote:
> > On Tue, 06 Mar 2007 08:53:20 -0500
> > James Smart <James.Smart@Emulex.Com> wrote:
> > 
> > > FYI - the *real* patch was posted to linux-scsi, and is under test at several
> > > locations. Again - please disregard this temporary solution.
> > 
> > Under what subject?
> 
> This one.
> 
> James
> 
> 
> 
> From: Hannes Reinecke <hare@suse.de>
> To: linux-scsi@vger.kernel.org
> Cc: james.smart@emulex.com, james.bottomley@steeleye.com, hch@lst.de
> Subject: [RFC] [PATCH] Resurrect sdev
> Date: 	Tue, 13 Feb 2007 19:29:01 +0100
> Sender: linux-scsi-owner@vger.kernel.org
> User-Agent: Mutt/1.5.9i
> 
> Hi all,
> 
> as discussed in San Jose here is a patch to resurrect sdevs which are
> in state SDEV_CANCEL / SDEV_DEL.

I included this in rc3-mm1 and rc3-mm2.   We have a scsi crash:

	http://test.kernel.org/abat/75741/debug/console.log

I have a couple of mpt patche sin there, but they're minor stuff.

I've queued a revert patch.  It'll take a while to get the results.  They
will appear at http://test.kernel.org/functional/index.html
