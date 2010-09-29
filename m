From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/3] tcm: Add Thin Provisioning / UNMAP emulation and
	Block Limits VPD page
Date: Wed, 29 Sep 2010 02:05:56 -0700
Message-ID: <1285751156.18417.57.camel@haakon2.linux-iscsi.org>
References: <1285627889-6450-1-git-send-email-nab@linux-iscsi.org>
	 <yq1sk0taeal.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.ac4.yahoo.com ([76.13.13.241]:32047 "HELO
	smtp102.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754940Ab0I2JKP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2010 05:10:15 -0400
In-Reply-To: <yq1sk0taeal.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>

On Tue, 2010-09-28 at 14:55 -0400, Martin K. Petersen wrote:
> >>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:
> 
> nab> This patch also adds the Block Limits VPD (0xb0) page
> 
> You should add the Thin Provisioning VPD page as well and set TPU and/or
> TPWS.
> 

Greetings mkp,

So I was looking at adding this VPD page orginally to set TPU=1 w/ DP=0
(because I don't believe there is currently way to get build the
PROVISIONING GROUP DESCRIPTORs from Block Discard knowledge), but I
ended getting a bit confused by the THRESHOLD EXPONENT, and what value
this should returned for the TCM/IBLOCK and TCM/FILEIO backstores when
blk_queue_discard()==1 is enabled.

Since this is currently not implemented in scsi_debug.c or used in any
way by sd.c AFAICT, do you have any additional information on how this
should be determined together with the UNMAP -> blk_issue_discard()
emulation bits..?

Thanks!

--nab

