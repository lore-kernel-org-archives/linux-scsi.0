From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 08/13] scsi: move request preps in other
	places into prep_fn()
Date: Tue, 05 Apr 2005 09:20:13 -0500
Message-ID: <1112710813.5764.13.camel@mulgrave>
References: <20050331090647.FEDC3964@htj.dyndns.org>
	 <20050331090647.94FFEC1E@htj.dyndns.org>
	 <1112292464.5619.30.camel@mulgrave> <20050401052542.GG11318@htj.dyndns.org>
	 <1112639944.5813.66.camel@mulgrave> <42522DD9.7020601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:44162 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261750AbVDEOUR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Apr 2005 10:20:17 -0400
In-Reply-To: <42522DD9.7020601@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, 2005-04-05 at 15:19 +0900, Tejun Heo wrote:
>   No problem.  Do you want me to do that now?  Or is it okay to do the 
> next take after you review the request_fn rewrite patch?

Just on resubmit ... I think you're currently reworking the request_fn
patch based on Christoph's comments, so resend the sequence when you
have this.

Thanks,

James


