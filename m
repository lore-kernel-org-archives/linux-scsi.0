From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 15:24:12 -0700 (PDT)
Message-ID: <20060516222412.22103.qmail@web31813.mail.mud.yahoo.com>
References: <1147804694.3505.76.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:23155 "HELO
	web31813.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S932215AbWEPWYN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 18:24:13 -0400
In-Reply-To: <1147804694.3505.76.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> The only current proposed user of this is libata-eh.  If you look,
> you'll see the caller is from ata_qc_complete() which is only called
> *after* the nexus is terminated.

"*after* the nexus is terminated"?

Are you saying that libata calls "done()" and then calls
"scsi_req_abort_cmd()" on the same command in succession?

I haven't looked in the code (which GIT tree is it?) but I don't
believe that Tejun would do such a thing.

     Luben

