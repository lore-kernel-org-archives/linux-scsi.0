From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: Re: [patch] ibmvscsi.c: remove max-sectors module parm
Date: Thu, 23 Dec 2004 14:01:53 -0600
Message-ID: <20041223200153.GA18386@cs.umn.edu>
References: <20041221223645.GA2736@cs.umn.edu> <1103828621.5290.42.camel@mulgrave>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.32.202]:27790 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S261157AbULWUBz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2004 15:01:55 -0500
Content-Disposition: inline
In-Reply-To: <1103828621.5290.42.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Dec 23, 2004 at 01:03:41PM -0600, James Bottomley wrote:
> On Tue, 2004-12-21 at 16:36 -0600, Dave C Boutcher wrote:
> > Description: Based on comments from Jens Axboe, remove
> > redundant module parm to set max sectors.  This should
> > be set through the /dev/block/xxx/queue/max_sectors_kb
> > interface.  This incremental patch fixes the only comments
> > received to the previous set of patches submitted.
> 
> This one doesn't apply to scsi-misc-2.6, could you reroll against what's
> there?

The patches I submitted on Tuesday are incremental on top of the four
patches from November 29th.  Let me know if you would like the
November 29th patches re-sent.

-- 
Dave Boutcher
