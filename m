From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] add sysfs attributes to scan and delete scsi_devices
Date: Tue, 8 Jul 2003 21:47:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030708214727.A13551@infradead.org>
References: <20030708134016.A32161@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:34570 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267627AbTGHUcy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jul 2003 16:32:54 -0400
Content-Disposition: inline
In-Reply-To: <20030708134016.A32161@beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Jul 08, 2003 at 01:40:16PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Tue, Jul 08, 2003 at 01:40:16PM -0700, Patrick Mansfield wrote:
> This patch against recent 2.5 bk adds a sysfs attribute to allow scanning
> (or rescanning) and deletion of scsi_devices.
> 
> It also allows scanning of entire hosts, channels, or targets.

Looks good so far but please keep the string parsing in scsi_sysfs.c
instead of scsi_scan.c.  Also doesn't want this some code sharing with
the old procfs code?

