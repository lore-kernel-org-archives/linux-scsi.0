From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH] fix leftover bytes calculation
Date: Thu, 11 Mar 2004 16:01:16 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4050FDCC.3000907@us.ibm.com>
References: <4050FC4D.4060002@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:15317 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261848AbUCLABS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2004 19:01:18 -0500
Received: from northrelay02.pok.ibm.com (northrelay02.pok.ibm.com [9.56.224.150])
	by e2.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id i2C01H7b392758
	for <linux-scsi@vger.kernel.org>; Thu, 11 Mar 2004 19:01:18 -0500
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i2C01Gfp089712
	for <linux-scsi@vger.kernel.org>; Thu, 11 Mar 2004 19:01:17 -0500
In-Reply-To: <4050FC4D.4060002@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


> On a related note I was wondering if the following is a
> bug or feature. At the bottom of scsi_io_completion, it calls
> scsi_end_request on the bytes for the current buffer.
> The comments indicate this is to handle improperly reported
> medium errors, but commands scsi_decide_disposition
> determined should not be retried end up getting
> requeued minus the current buffer.

Oh wait, forget that. I wasn't sure if those medium errors
described in the comments were incorrectly reported as any old
error or if there was some way to narrow it down.

