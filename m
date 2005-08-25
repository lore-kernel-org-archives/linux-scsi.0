From: Drew Winstel <raw@dslr.net>
Subject: Re: qla2xxx: does not respond to SCSI_IOCTL_PROBE_HOST
Date: Thu, 25 Aug 2005 11:02:23 -0500
Message-ID: <1124985743.15175.6.camel@localhost>
References: <1124915655.13251.16.camel@localhost>
	 <20050824211348.GH8205@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dslreports.com ([209.123.192.187]:62671 "EHLO
	mail.dslr.net") by vger.kernel.org with ESMTP id S932222AbVHYQBx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Aug 2005 12:01:53 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.dslr.net (Postfix) with ESMTP id 7956442C0B
	for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2005 12:01:51 -0400 (EDT)
Received: from mail.dslr.net ([127.0.0.1])
 by localhost (coral.dslreports.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 32071-01 for <linux-scsi@vger.kernel.org>;
 Thu, 25 Aug 2005 12:01:51 -0400 (EDT)
In-Reply-To: <20050824211348.GH8205@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2005-08-24 at 14:13 -0700, Andrew Vasquez wrote:

> Not sure how we want to fix it, perhaps for backwards compatibility,
> increment present regardless of the value of proc_info.
> 
> Something like this, perhaps (untested)?

Thanks for the patch, Andrew.

It certainly appears to work (the ioctl new returns qla2xxx), although I
have not done any in-depth testing other than issuing the ioctl to
drives connected to both the QLA2200 and the Adaptec 29160.  

Should this patch be added to the tree (assuming more testing, of
course)?


Thanks again,
Drew

