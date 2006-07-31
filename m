From: "HighPoint Linux Team" <linux@highpoint-tech.com>
Subject: Re: [PATCH] hptiop: backout ioctl mess
Date: Mon, 31 Jul 2006 10:53:29 +0800
Message-ID: <08ce01c6b44c$82b8ef70$1200a8c0@gmm>
References: <20060730171336.GA31646@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stats.hypersurf.com ([209.237.0.12]:19980 "EHLO
	stats.hypersurf.com") by vger.kernel.org with ESMTP id S932436AbWGaCvz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jul 2006 22:51:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> The hptiop just got merged with a horrible amount of really bad ioctl
> code that is against the standards for new scsi drivers.  This patch
> backs it out (and fixes a small bug where scsi_add_host is called to
> early).  We can re-add proper APIs once we agree on them.

What is the standard implemetation of private ioctls for scsi drivers?
Thanks.

HighPoint Linux Team

