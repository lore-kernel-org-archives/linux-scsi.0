From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Thu, 6 Nov 2003 10:51:40 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031106105140.A15912@infradead.org>
References: <B179AE41C1147041AA1121F44614F0B060ED62@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:31760 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263518AbTKFKvl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2003 05:51:41 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060ED62@AVEXCH02.qlogic.org>; from andrew.vasquez@qlogic.com on Tue, Nov 04, 2003 at 05:15:33PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>

More comments:

 - qla_vendor.c is still unused and should be killed
 - your ioctl API gets worse and worse.  You don't expect this huge
   dungpile of ioctls all marked _BAD to be merged, do you?
   Also having different ioctl values for different plattforms is
   not an option for Linux.
