From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] Remove two cancel_delayed_work() calls from the error
 handler
Date: Tue, 27 May 2014 11:06:03 +0200
Message-ID: <5384557B.8040908@redhat.com>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org>		 <53835C55.6070400@redhat.com> <5384476F.6010705@acm.org>	 <1401178172.14454.12.camel@dabdike> <53844E8E.7010404@acm.org> <1401180980.14454.31.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbaE0JGi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2014 05:06:38 -0400
In-Reply-To: <1401180980.14454.31.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, "bvanassche@acm.org" <bvanassche@acm.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "jdl1291@gmail.com" <jdl1291@gmail.com>

Il 27/05/2014 10:56, James Bottomley ha scritto:
> The whole reason BUG_ON doesn't leave a log trace is to try to prevent
> corruption propagating to the data storage devices.  What you propose
> would be inviting that corruption in the name of getting a log entry.

Even this is not entirely correct.  kdump can be used to capture the 
full log of the BUG_ON.

Paolo
