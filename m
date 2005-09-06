From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: Re: [PATCH] IBM VSCSI Client: handle large scatter/gather lists
Date: Tue, 6 Sep 2005 16:16:21 -0500
Message-ID: <20050906211621.GA14057@cs.umn.edu>
References: <42C2D85E.5010306@us.ibm.com> <20050906074943.GS6945@krispykreme> <1126016005.5012.1.camel@mulgrave>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.33.102]:3024 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S1750960AbVIFVQ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2005 17:16:26 -0400
Content-Disposition: inline
In-Reply-To: <1126016005.5012.1.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Anton Blanchard <anton@samba.org>, Linda Xie <lxiep@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Santiago Leon <santil@us.ibm.com>

On Tue, Sep 06, 2005 at 09:13:25AM -0500, James Bottomley wrote:
> On Tue, 2005-09-06 at 17:49 +1000, Anton Blanchard wrote:
> > Any chance we could get this into 2.6.14? I just tested it on current
> > git and as expected the number of sg elements increased. Testing a dd
> > from a virtual disk with clustering disabled (to avoid physical merging
> > effects) shows:
> 
> Yes ... but according to my records it wasn't acked by the
> maintainer ... does he agree?

Yes.  Acking Linda's patches has been on my todo list for month..sorry
for the lag.

-- 
Dave Boutcher
