From: Drew Winstel <raw@dslr.net>
Subject: Re: qla2xxx: does not respond to SCSI_IOCTL_PROBE_HOST
Date: Thu, 25 Aug 2005 12:02:58 -0500
Message-ID: <1124989378.15175.17.camel@localhost>
References: <1124915655.13251.16.camel@localhost>
	 <20050824211348.GH8205@plap.qlogic.org>
	 <20050825160902.GA17366@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dslreports.com ([209.123.192.187]:53474 "EHLO
	mail.dslr.net") by vger.kernel.org with ESMTP id S1751202AbVHYRCc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Aug 2005 13:02:32 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.dslr.net (Postfix) with ESMTP id 4C7AF427BD
	for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2005 13:02:27 -0400 (EDT)
Received: from mail.dslr.net ([127.0.0.1])
 by localhost (coral.dslreports.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 13142-10 for <linux-scsi@vger.kernel.org>;
 Thu, 25 Aug 2005 13:02:27 -0400 (EDT)
In-Reply-To: <20050825160902.GA17366@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org

On Thu, 2005-08-25 at 17:09 +0100, Christoph Hellwig wrote:
> And while we're at it we should add deprecation warnings for most of
> the crufy ioctls in scsi_ioctl.c..
> 
Pardon my ignorance, but to which ioctls are you referring?  Are
practically all the ioctls now just junk, or is there a list somewhere
of ones that are slated for deprecation and removal?

Thanks,
Drew

