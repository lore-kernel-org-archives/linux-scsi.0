From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: read only scsi disk
Date: Thu, 9 Feb 2006 12:02:25 -0700
Message-ID: <20060209190225.GI1593@parisc-linux.org>
References: <1139504647.9367.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:26307 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750715AbWBITC1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 14:02:27 -0500
Content-Disposition: inline
In-Reply-To: <1139504647.9367.57.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Zhang <mingz@ele.uri.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Damian Pietras <daper@daper.net>

On Thu, Feb 09, 2006 at 12:04:07PM -0500, Ming Zhang wrote:
> We are adding the support for an OSS iscsi target to support export an
> iscsi disk as readonly. We set correct read only bit in sense dbd. But
> we found that only when we set the removable bit, the linux will
> actually check the ro bit. more detail information can be found from

Surely all iSCSI discs are removable, since anyone could unplug the
network cable at any time ...
