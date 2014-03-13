From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/5] Add EVPD page 0x83 to sysfs
Date: Wed, 12 Mar 2014 21:53:12 -0400
Message-ID: <yq18use27av.fsf@sermon.lab.mkp.net>
References: <1394461725-76203-1-git-send-email-hare@suse.de>
	<1394461725-76203-4-git-send-email-hare@suse.de>
	<1394475897.2565.46.camel@dabdike.int.hansenpartnership.com>
	<531E25F3.6090102@suse.de>
	<1394511243.2142.1.camel@dabdike.int.hansenpartnership.com>
	<531EF9D9.9040208@suse.de>
	<1394535351.2142.35.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40904 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaCMByJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2014 21:54:09 -0400
In-Reply-To: <1394535351.2142.35.camel@dabdike.int.hansenpartnership.com>
	(James Bottomley's message of "Tue, 11 Mar 2014 10:55:54 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "hch@infradead.org" <hch@infradead.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "jlinton@tributary.com" <jlinton@tributary.com>, "kai.makisara@kolumbus.fi" <kai.makisara@kolumbus.fi>, "kay@vrfy.org" <kay@vrfy.org>

>>>>> "James" == James Bottomley <jbottomley@parallels.com> writes:

James> What we do under the covers is up to us.  What's the reason for
James> not wanting to do I/O every time?  Getting VPD data isn't a time
James> critical operation is it?  so what's the benefit of caching it?

XCopy. Want us to do a VPD page query for every command (~32 megs of
data)?

-- 
Martin K. Petersen	Oracle Linux Engineering
