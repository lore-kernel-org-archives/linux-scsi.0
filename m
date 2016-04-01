From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/5] bnx2fc: Check sc_cmd device and host pointer before
 returning the command to the mid-layer.
Date: Fri, 01 Apr 2016 16:02:11 +0200
Message-ID: <409247b5a06ce88a83b5be0d299e5853@suse.de>
References: <1459516223-32106-1-git-send-email-chad.dupuis@qlogic.com>
 <1459516223-32106-5-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbcDAOCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 10:02:13 -0400
In-Reply-To: <1459516223-32106-5-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, saurav.kashyap@qlogic.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2016-04-01 15:10, Chad Dupuis wrote:
> When we are in connection recovery and the internal command timer on a 
> request
> pops, either the scsi_cmnd->device or scsi_cmnd->device->host back 
> pointers may
> be NULL as the device that the command that the request was submitted 
> on may
> have been subsequently reaped due to the connection recovery. This can 
> cause
> one or both of the pointers above to be NULL and cause a system crash 
> if we try
> to return the command to the midlayer.
> 
> Instead, double check the pointers before the return to the midlayer so 
> as to
> prevent the crash and let the upper layers finish the session recovery 
> and
> rediscover the device.
> 
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
