From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] remove scsi_device proc printing from drivers
Date: Sun, 27 Apr 2003 11:10:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030427111010.B21878@beaverton.ibm.com>
References: <20030427185628.A30233@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:34038 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S261292AbTD0SBn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 14:01:43 -0400
Content-Disposition: inline
In-Reply-To: <20030427185628.A30233@lst.de>; from hch@lst.de on Sun, Apr 27, 2003 at 06:56:28PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Sun, Apr 27, 2003 at 06:56:28PM +0200, Christoph Hellwig wrote:

> BTW, does someone have opintions on reading of /proc/scsi/scsi?
> It's just a duplication of the sysfs tree so it should probably
> go away also.  OTOH there's a slightly higher chance on userland
> actually using this than for the LLDDs..

IMO leave it for 2.6, and remove /proc/scsi/scsi read (and maybe writes,
if we have sysfs replacement in 2.6) in 2.7.

-- Patrick Mansfield
