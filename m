From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 04/08] scsi: remove meaningless volatile
	qualifiers from structure definitions
Date: Tue, 22 Mar 2005 22:15:27 -0600
Message-ID: <1111551327.5520.99.camel@mulgrave>
References: <20050323021335.960F95F8@htj.dyndns.org>
	 <20050323021335.2655518E@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:14055 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262632AbVCWEPb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 23:15:31 -0500
In-Reply-To: <20050323021335.2655518E@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, 2005-03-23 at 11:14 +0900, Tejun Heo wrote:
> 	scsi_device->device_busy, Scsi_Host->host_busy and
> 	->host_failed have volatile qualifiers, but the qualifiers
> 	don't serve any purpose.  Kill them.  While at it, protect
> 	->host_failed update in scsi_error for consistency and clarity.

Well ... the data here is volatile so what you're advocating is a move
away from a volatile variable model to a protected variable one ... did
you audit all users of both of these to make sure we have protection on
all of them?  It looks like the sata strategy handlers would still rely
on the volatile data.

James


