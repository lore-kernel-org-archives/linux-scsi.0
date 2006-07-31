From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] hptiop: backout ioctl mess
Date: Sun, 30 Jul 2006 23:19:31 -0400
Message-ID: <44CD76C3.2060103@torque.net>
References: <20060730171336.GA31646@lst.de> <08ce01c6b44c$82b8ef70$1200a8c0@gmm>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35810 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932512AbWGaDTn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jul 2006 23:19:43 -0400
In-Reply-To: <08ce01c6b44c$82b8ef70$1200a8c0@gmm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

HighPoint Linux Team wrote:
> Christoph Hellwig wrote:
>> The hptiop just got merged with a horrible amount of really bad ioctl
>> code that is against the standards for new scsi drivers.  This patch
>> backs it out (and fixes a small bug where scsi_add_host is called to
>> early).  We can re-add proper APIs once we agree on them.
> 
> What is the standard implemetation of private ioctls for scsi drivers?

Don't get caught.

You might try something creative like:
#define foo ioctl

More seriously see:
http://lwn.net/Articles/191653/
for a recent discussion.

Doug Gilbert

