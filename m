From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: Re: [patch] ibmvscsi.c: limit size of I/O requests, updated
Date: Fri, 31 Dec 2004 13:19:48 -0600
Message-ID: <20041231191948.GA11286@cs.umn.edu>
References: <20041129203107.GB31011@cs.umn.edu> <20041231174745.GA10894@cs.umn.edu> <1104520241.5247.13.camel@mulgrave>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.32.202]:59345 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S262138AbULaTTt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Dec 2004 14:19:49 -0500
Content-Disposition: inline
In-Reply-To: <1104520241.5247.13.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Dec 31, 2004 at 01:10:40PM -0600, James Bottomley wrote:
> Can you look at the scsi-misc-2.6 tree (or the current BK head plus the
> scsi-misc-2.6 patch from http://parisc-linux.org/~jejb/scsi_diffs/) and
> tell me what (if anything) I'm still missing?

Thanks, scsi-misc-2.6 has the patch in question.  There are three other
patches floating around the ether somewhere that move the driver up to
version 1.5.5.  I'll resend those.

-- 
Dave Boutcher
