From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 2/3] block: Introduce blk_rq_completed()
Date: Mon, 26 May 2014 15:27:06 +0000
Message-ID: <1401118025.3303.5.camel@dabdike>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org>
	 <53835A77.1090708@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:48952 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaEZP1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 May 2014 11:27:07 -0400
In-Reply-To: <53835A77.1090708@acm.org>
Content-Language: en-US
Content-ID: <BF6882B3EA39124A93AED0A2553EA95E@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bvanassche@acm.org" <bvanassche@acm.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "jdl1291@gmail.com" <jdl1291@gmail.com>

On Mon, 2014-05-26 at 17:15 +0200, Bart Van Assche wrote:
> Make it possible to test the REQ_ATOM_COMPLETE bit from outside the
> block layer core.

I don't see the value of patches 2,3 they're checking for an impossible
condition ... why might it be possible?

James

