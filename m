From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: PATCH: Quieten sparse on lpfc driver
Date: Thu, 15 Jun 2006 16:27:54 +0100
Message-ID: <20060615152754.GS27946@ftp.linux.org.uk>
References: <1150386046.3490.94.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51926 "EHLO
	ZenIV.linux.org.uk") by vger.kernel.org with ESMTP id S1030528AbWFOP1z
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 11:27:55 -0400
Content-Disposition: inline
In-Reply-To: <1150386046.3490.94.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org

On Thu, Jun 15, 2006 at 04:40:46PM +0100, Alan Cox wrote:
> No actual bugs I can see just labelling needed and 0/NULL fixes

ACK, but I thought we are too late for that in this cycle...

Al, sitting on ~200 patches of such kind, including

commit aed9ad56701ffb209b7e2f4e52612739b7460fc8
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun May 28 14:57:07 2006 -0400

    [PATCH] scsi/lpfc __iomem annotations, NULL noise removal
