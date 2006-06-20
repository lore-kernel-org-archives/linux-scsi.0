From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.17
Date: Tue, 20 Jun 2006 17:21:39 -0400
Message-ID: <449866E3.8010200@garzik.org>
References: <1150837947.2531.27.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:12514 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751113AbWFTVVo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jun 2006 17:21:44 -0400
In-Reply-To: <1150837947.2531.27.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> This represents the almost complete SCSI pending list apart from a SAS
> port update which we're still trying to beat into shape.  The patch can
> be pulled from here:

When will aic94xx head upstream?  Even though it is seeing changes in 
your repo, I would rather not hide the driver for another six months.

aic94xx is the only all-software-stack SAS user at present, so I think 
its reasonable to get it into the tree, and make changes upstream.

	Jeff



