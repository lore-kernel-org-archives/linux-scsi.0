From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 3/5] Add EVPD page 0x83 to sysfs
Date: Thu, 13 Mar 2014 03:31:51 +0000
Message-ID: <1394681509.3022.46.camel@dabdike.int.hansenpartnership.com>
References: <1394461725-76203-1-git-send-email-hare@suse.de>
	 <1394461725-76203-4-git-send-email-hare@suse.de>
	 <1394475897.2565.46.camel@dabdike.int.hansenpartnership.com>
	 <531E25F3.6090102@suse.de>
	 <1394511243.2142.1.camel@dabdike.int.hansenpartnership.com>
	 <531EF9D9.9040208@suse.de>
	 <1394535351.2142.35.camel@dabdike.int.hansenpartnership.com>
	 <yq18use27av.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:34373 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaCMDce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2014 23:32:34 -0400
In-Reply-To: <yq18use27av.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Content-ID: <79322726CF987147B4ED0960777F5116@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "jlinton@tributary.com" <jlinton@tributary.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "kay@vrfy.org" <kay@vrfy.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kai.makisara@kolumbus.fi" <kai.makisara@kolumbus.fi>

On Wed, 2014-03-12 at 21:53 -0400, Martin K. Petersen wrote:
> >>>>> "James" == James Bottomley <jbottomley@parallels.com> writes:
> 
> James> What we do under the covers is up to us.  What's the reason for
> James> not wanting to do I/O every time?  Getting VPD data isn't a time
> James> critical operation is it?  so what's the benefit of caching it?
> 
> XCopy. Want us to do a VPD page query for every command (~32 megs of
> data)?

Really?  OK, caching it is.

James

