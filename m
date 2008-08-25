From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/2] scsi: scsi_dh check_sense return ADD_TO_MLQUEUE
Date: Mon, 25 Aug 2008 13:02:32 -0700
Message-ID: <1219694552.14830.116.camel@chandra-ubuntu>
References: <1218568318-4065-1-git-send-email-andmike@linux.vnet.ibm.com>
	 <1218568318-4065-2-git-send-email-andmike@linux.vnet.ibm.com>
	 <48B2A6AD.5040809@suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:33767 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbYHYUDH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2008 16:03:07 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7PK32qQ029630
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2008 16:03:02 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7PK32ao121582
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2008 14:03:02 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7PK329V017502
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2008 14:03:02 -0600
In-Reply-To: <48B2A6AD.5040809@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>


On Mon, 2008-08-25 at 14:33 +0200, Hannes Reinecke wrote:
> Hi Mike,
> 
> Mike Anderson wrote:
> > Change scsi_dh check_sense functions to return ADD_TO_MLQUEUE
> > to allow retries to occur without restriction of blk_noretry_request
> > check.
> > 
> Correct. Error on my side.
> 
> > Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

