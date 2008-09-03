From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 01/14] block: separate failfast into multiple bits.
Date: Wed, 03 Sep 2008 11:27:39 +0300
Message-ID: <48BE4A7B.3090707@panasas.com>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com> <1220371543-15099-2-git-send-email-andmike@linux.vnet.ibm.com> <da824cf30809020935k6a05df54yf0a2eda1ecc9e65e@mail.gmail.com> <48BD70E6.5020702@cs.wisc.edu> <20080902173114.GA27138@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:4823 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751170AbYICIeS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2008 04:34:18 -0400
In-Reply-To: <20080902173114.GA27138@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Grant Grundler <grundler@google.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>

Mike Anderson wrote:
> 
> I can work on a patch to the scsi_mid_low_api.txt document that describes
> the mapping / policy of these changes (i.e., DID_* / sense to
> SCSI_MLQUEUE_DIS_* mapping to blk_failfast_* mapping ). 
> 
> -andmike
> --
> Michael Anderson
> andmike@linux.vnet.ibm.com

This could be grate thanks. Please make sure it will contain all the
information you posted in the [0/14] email.

Thanks again
Boaz
