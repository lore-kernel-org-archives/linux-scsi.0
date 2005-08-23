From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] scsi: /proc/scsi/scsi patch for large number of devices
Date: Tue, 23 Aug 2005 11:01:18 -0700
Message-ID: <20050823180118.GB6914@us.ibm.com>
References: <1124815241.22518.11.camel@markh1.pdx.osdl.net> <20050823174206.GA12359@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:25579 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S932261AbVHWSBY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 14:01:24 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j7NI1NNN235198
	for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2005 14:01:23 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7NI0q0I531672
	for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2005 12:00:52 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j7NI1LMm016780
	for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2005 12:01:22 -0600
Content-Disposition: inline
In-Reply-To: <20050823174206.GA12359@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Aug 23, 2005 at 06:42:06PM +0100, Christoph Hellwig wrote:

> We had this before, and the answer is: don't use /proc/scsi if you have
> lots of device.  Don't even enable the config option.

We still don't have sysfs scsi devinfo support, we need to represent it as
a modifiable list or such under sysfs.

-- Patrick Mansfield
