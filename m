From: Christoph Hellwig <hch@infradead.org>
Subject: Re: new driver
Date: Sun, 15 Feb 2004 09:29:18 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040215092918.A6176@infradead.org>
References: <200402141906.12087.kschneider@bout-tyme.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:37394 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264419AbUBOJ3T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Feb 2004 04:29:19 -0500
Content-Disposition: inline
In-Reply-To: <200402141906.12087.kschneider@bout-tyme.net>; from kschneider@bout-tyme.net on Sat, Feb 14, 2004 at 07:06:12PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Ken Schneider <kschneider@bout-tyme.net>
Cc: linux-scsi@vger.kernel.org

On Sat, Feb 14, 2004 at 07:06:12PM -0500, Ken Schneider wrote:
> I have been sent the sources for the LSI LOGIC, Inc. Ultra ATA100 IDE raid 
> controller as found on the mainboard of the HP ML330 computer. I requested 
> information concerning the inclusion of the code into the kernel tree and 
> have been informed that the source is open and can be included as stated in 
> all of the .c and .h files.

We're generally not including software raid as LLDD.  We'd be interested in
both drivers for the underlying ide controller (if not yet support by linux)
and a tool to setup the tables for device mapper.

btw, where is the source for the driver you're talking about?

