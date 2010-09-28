From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] tcm: Add Thin Provisioning / UNMAP emulation and Block Limits VPD page
Date: Tue, 28 Sep 2010 14:55:30 -0400
Message-ID: <yq1sk0taeal.fsf@sermon.lab.mkp.net>
References: <1285627889-6450-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:20382 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757420Ab0I1S5C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2010 14:57:02 -0400
In-Reply-To: <1285627889-6450-1-git-send-email-nab@linux-iscsi.org> (Nicholas
	A. Bellinger's message of "Mon, 27 Sep 2010 15:51:28 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

nab> This patch also adds the Block Limits VPD (0xb0) page

You should add the Thin Provisioning VPD page as well and set TPU and/or
TPWS.

-- 
Martin K. Petersen	Oracle Linux Engineering
