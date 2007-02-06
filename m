From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 25/33] Fix the reproducible oops in scsi
Date: Tue, 6 Feb 2007 11:39:42 -0800
Message-ID: <20070206113942.afbc019b.akpm@linux-foundation.org>
References: <200702060040.l160e04u005027@shell0.pdx.osdl.net>
	<1170775326.3634.14.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47895 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbXBFTj6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Feb 2007 14:39:58 -0500
In-Reply-To: <1170775326.3634.14.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, hirofumi@mail.parknet.co.jp, James.Smart@Emulex.Com

On Tue, 06 Feb 2007 09:22:06 -0600
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Mon, 2007-02-05 at 16:38 -0800, akpm@linux-foundation.org wrote:
> > From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> > 
> > I got the oops after some hotplug events. And the similar oops can
> > reproduce by the following step.
> 
> James Smart already pointed out that this fix isn't valid ... it's a
> bandaid that doesn't fix the underlying problem.
> 

That's why I included his comments in the changelog.

Is anyone going to fix it for real?  Do we know _how_ it should be fixed?
