From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Allow both megaraid drivers to be built
Date: Mon, 29 Aug 2005 16:02:09 +0100
Message-ID: <20050829150209.GA5563@infradead.org>
References: <431320AB.7010303@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44214 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750982AbVH2PCO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 11:02:14 -0400
Content-Disposition: inline
In-Reply-To: <431320AB.7010303@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Drake <dsd@gentoo.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, sreenib@lsil.com, sju@lsil.com

On Mon, Aug 29, 2005 at 03:50:19PM +0100, Daniel Drake wrote:

ifdef on other drivers is bogus, please remove the pci ids completely
from the old driver.  It'd probably be a good idea to rename it to
megaraid_legacy aswell.  I've also asked the LSI Engineers whether they
could help identifying what code could be remove when only supporting
the two oldes chips but haven't gotten a reply yet.  I hope they'll
be able to answer when they're less busy.
