From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: [PATCH] Add FC transport attributes support to qla2xxx
Date: Tue, 23 Mar 2004 10:44:20 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040323184420.GA21065@praka.local.home>
References: <20040322184005.GT19428@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:58304 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S262788AbUCWTIJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2004 14:08:09 -0500
Content-Disposition: inline
In-Reply-To: <20040322184005.GT19428@localhost>
List-Id: linux-scsi@vger.kernel.org
To: Martin Hicks <mort@wildopensource.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 22 Mar 2004, Martin Hicks wrote:

> Here is a patch that adds FC transport attributes to the qla2xxx driver.
> The patch should apply cleanly to a recent 2.6 kernel with the FC
> attributes update that I just sent to linux-scsi.
> 
> There are two patches.  The first one contains the driver changes and
> the second one contains a Kconfig update.
> 

The changes look fine, I'll integrate them into our tree. James,
please apply to your latest bk-tree.

Thanks,
Andrew Vasquez
