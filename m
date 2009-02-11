From: "Sachin P. Sant" <sachinp@in.ibm.com>
Subject: Re: [patch] powerpc/ps3: Use hard coded values for LV1 device type
Date: Wed, 11 Feb 2009 10:58:34 +0530
Message-ID: <49926202.3010405@in.ibm.com>
References: <498C6C49.1010200@in.ibm.com>  <498CF52E.4040903@am.sony.com> <1234092590.10240.4.camel@localhost> <1234138267.31963.77.camel@pasglop> <1234151988.8776.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:52689 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbZBKF2l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2009 00:28:41 -0500
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id n1B5RUu0004003
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2009 16:27:30 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n1B5St6G1191946
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2009 16:28:56 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1B5SaTr023072
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2009 16:28:37 +1100
In-Reply-To: <1234151988.8776.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-scsi <linux-scsi@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org, Jens Axboe <jens.axboe@oracle.com>

James Bottomley wrote:
> Actually, I think the fix lies in scsi.h ... we can make that into a
> nicely independent protocol header file.  Your current woes come because
> it pulls in scsi_cmnd.h ... perhaps just getting rid of this will fix
> it.
>
> Can the rest of linux-scsi verify that the fix below doesn't break
> something else?
>
> I found one cockup: block/cmd-filter.c is apparently not including
> linuc/blkdev.h directly but via scsi/scsi.h ... I fixed this up.
>   
Tested the patch and it fixes the issue.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

