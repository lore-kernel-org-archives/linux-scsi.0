From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] pull scsi_scan_host out of scsi_add_host
Date: Tue, 8 Jul 2003 01:03:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030708080334.GA2451@beaverton.ibm.com>
References: <20030707143056.GA1177@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:26278 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S266913AbTGHHqt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jul 2003 03:46:49 -0400
Content-Disposition: inline
In-Reply-To: <20030707143056.GA1177@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig [hch@lst.de] wrote:
> As Douglas mentioned on this list a while ago there's hardware these
> days where we don't want to automatically perform an initial bus scan
> in scsi_add_host.  Currently we only have ieee1394 in the tree but
> I can imagine more uses like iscsi or certain fc setups.
> 
> This patch removes the call to scsi_scan_host from scsi_add_host
> and moves it into the drivers that want in.

Would we want to make a symmetric interface and pull the
unscan out of scsi_remove_host also?

-andmike
--
Michael Anderson
andmike@us.ibm.com

