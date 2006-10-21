From: Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 45/45] drivers/scsi: Handcrafted MIN/MAX macro removal
Date: Sat, 21 Oct 2006 15:04:13 -0700
Message-ID: <20061021150413.14c4a260.akpm@osdl.org>
References: <200610202148.k9KLmeXZ004210@shell0.pdx.osdl.net>
	<20061020151928.2926816c.akpm@osdl.org>
	<1161466081.17804.107.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:16869 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1161067AbWJUWEQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Oct 2006 18:04:16 -0400
In-Reply-To: <1161466081.17804.107.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Sat, 21 Oct 2006 16:28:01 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Fri, 2006-10-20 at 15:19 -0700, Andrew Morton wrote:
> > I've been maintaining some of these scsi patches for over a year.  Please
> > either merge them, nack-with-reasons or indicate that I should merge them.
> 
> Actually, we have a bit of a record in this batch.  I selected 25 for
> immediate application, out of which I got 24 rejections.  It looks like
> most of the rejections are because the patch is already in my
> scsi-rc-fixes-2.6 tree.  Could you check this is actually being included
> in -mm?

Oh.  I dropped rc-fixes many months ago because it had lots of things which
were also in scsi-misc.  Or vice versa.  That seems to be sorted out now,
so I'll bring rc-fixes back.

> The active SCSI trees that should be included in mm are
> 
> scsi-rc-fixes-2.6
> scsi-misc-2.6
> aic94xx-sas-2.6
> 
> The remaining patches are all minor cleanup suggestions that are waiting
> on maintainers.  (unfortunately, maintainers aren't really greatly
> incented to look through patches like "make a varaible static").
> 

They probably don't think there's a need to commnet on obvious things.
