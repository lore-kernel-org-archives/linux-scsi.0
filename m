From: Matthew Wilcox <willy@debian.org>
Subject: Re: zalon/ncr53c720 crashes K460  (parisc port) on bootup.
Date: Sat, 27 Sep 2003 21:06:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030927200602.GU24824@parcelfarce.linux.theplanet.co.uk>
References: <1064634188.641.27.camel@laptop.bradetich.net> <1064677551.2002.20.camel@mulgrave> <20030927183756.GT24824@parcelfarce.linux.theplanet.co.uk> <1064689088.2002.188.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:34466 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261644AbTI0UGE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Sep 2003 16:06:04 -0400
Content-Disposition: inline
In-Reply-To: <1064689088.2002.188.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <willy@debian.org>, Ryan Bradetich <rbradetich@uswest.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, PARISC list <parisc-linux@lists.parisc-linux.org>

On Sat, Sep 27, 2003 at 01:58:06PM -0500, James Bottomley wrote:
> No, I fixed that...that was changed to goto out; in my patch, and out
> was just before the return (i.e. no longer do the release).

Oops, I didn't scroll all the way down.  Anyway, we have a tradition
of allowing, eg, kfree(NULL) to succeed, so it's a little more robust.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
