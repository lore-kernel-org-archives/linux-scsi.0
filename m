From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: aic94xx IO errors with "escb_tasklet_complete: phy0: REQ_TASK_ABORT"
Date: Wed, 04 Oct 2006 13:12:30 -0700
Message-ID: <452415AE.7030202@us.ibm.com>
References: <20061004164438.GC5091@rhun.haifa.ibm.com> <20061004132929.A29689@florence.linkmargin.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:28394 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751049AbWJDUMi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Oct 2006 16:12:38 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k94KCWv2007597
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 16:12:32 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k94KCWAP340334
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 14:12:32 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k94KCVmO027235
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 14:12:32 -0600
In-Reply-To: <20061004132929.A29689@florence.linkmargin.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Warner <andyw@pobox.com>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Andy Warner wrote:

> So you are seeing legitimate REQ_TASK_ABORT values, but need to look
> at the remaining data to see what the chip is trying to tell you.
> For REQ_TASK_ABORT, status_block[1..2] is the transaction context,
> and status_block[3] is the reason (TC_NO_ERROR etc from aic94xx_sas.h)

Funny, I've been trying to write at least a REQ_TASK_ABORT handler all
week.  I'm having a bit of trouble using the transaction context...
mostly because the value I'm getting doesn't correspond to any ascb.
Assuming, of course, that ascb->scb->header.index/ascb->tc_index are
indeed transaction contexts.

--D

