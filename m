From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 02/13] scsi: don't turn on REQ_SPECIAL on
	sgtable allocation failure.
Date: Thu, 31 Mar 2005 11:53:45 -0600
Message-ID: <1112291625.5619.21.camel@mulgrave>
References: <20050331090647.FEDC3964@htj.dyndns.org>
	 <20050331090647.C0E52845@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:63134 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261594AbVCaRxz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 12:53:55 -0500
In-Reply-To: <20050331090647.C0E52845@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Thu, 2005-03-31 at 18:08 +0900, Tejun Heo wrote:
> 	Don't turn on REQ_SPECIAL on sgtable allocation failure.  This
> 	was the last place where REQ_SPECIAL is turned on for normal
> 	requests.

If you do this, you'll leak a command every time the sgtable allocation
fails.

James


