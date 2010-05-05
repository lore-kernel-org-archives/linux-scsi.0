From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/9] blk: Do not abort requests if queue is stopped
Date: Wed, 5 May 2010 11:18:29 -0700
Message-ID: <20100505181829.GA4053@linux.vnet.ibm.com>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
 <1272944228-30511-2-git-send-email-andmike@linux.vnet.ibm.com>
 <20100504104537.GN27497@kernel.dk>
 <20100505045231.GA25395@linux.vnet.ibm.com>
 <4BE1B55B.9090007@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:45189 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352Ab0EESS6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2010 14:18:58 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o45IBaRF025008
	for <linux-scsi@vger.kernel.org>; Wed, 5 May 2010 12:11:36 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o45IIifM068824
	for <linux-scsi@vger.kernel.org>; Wed, 5 May 2010 12:18:45 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o45BIZFG013948
	for <linux-scsi@vger.kernel.org>; Wed, 5 May 2010 05:18:36 -0600
Content-Disposition: inline
In-Reply-To: <4BE1B55B.9090007@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com

Mike Christie <michaelc@cs.wisc.edu> wrote:
> All iscsi drivers should have blocking and timer reset now, so if a
> transport problem casues a IO error to be sent to dm, then when
> blk_abort_request is called that should prevent the scsi layer from
> sending the whole host into recovery.
> 
> 
> I do not remember the problem with the lack of eh blocking though.
> Did we need that too?

My comment was not on need I was just comparing the transports.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
