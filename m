From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 17:29:38 -0500
Message-ID: <1147818578.3505.92.camel@mulgrave.il.steeleye.com>
References: <20060516222412.22103.qmail@web31813.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:59035 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932187AbWEPWbr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 18:31:47 -0400
In-Reply-To: <20060516222412.22103.qmail@web31813.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2006-05-16 at 15:24 -0700, Luben Tuikov wrote:
> "*after* the nexus is terminated"?
> 
> Are you saying that libata calls "done()" and then calls
> "scsi_req_abort_cmd()" on the same command in succession?

no, I'm saying ata_qc_complete() is an indication from the driver that
the nexus is terminated.

> I haven't looked in the code (which GIT tree is it?) but I don't
> believe that Tejun would do such a thing.

It's in the libata-dev tree on www.kernel.org/git

James


