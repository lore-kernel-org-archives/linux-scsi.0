From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 08/13] scsi: move request preps in other
	places into prep_fn()
Date: Mon, 04 Apr 2005 13:39:04 -0500
Message-ID: <1112639944.5813.66.camel@mulgrave>
References: <20050331090647.FEDC3964@htj.dyndns.org>
	 <20050331090647.94FFEC1E@htj.dyndns.org>
	 <1112292464.5619.30.camel@mulgrave> <20050401052542.GG11318@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:35298 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261327AbVDDSjP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2005 14:39:15 -0400
In-Reply-To: <20050401052542.GG11318@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Fri, 2005-04-01 at 14:25 +0900, Tejun Heo wrote:
>  Ah.. with later requeue path consolidation patches, all requests get
> their sense buffer cleared during requeueing, which, IMHO, is more
> logical.  Moving scsi_init_cmd_errh() should come after the patch.
> Sorry. :-)
> 
>  I'll make another take of this patchset (maybe subset) after issues
> are resolved.  I'll split and reorder relocation of scsi_init_cmd_errh
> then.

Thanks.  It would help me enormously if you explained what bugs you were
fixing at the top of each patch, and also only do patchsets that are
dependent on each other (I already have your serial_numer_at_timeout and
internal_timeout removal patches in the scsi-misc-2.6 tree).

James


