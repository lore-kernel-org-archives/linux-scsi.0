From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH] iscsi driver update 4.0.1.8
Date: Thu, 15 Jul 2004 10:40:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F6C193.9030906@us.ibm.com>
References: <200407151602.45830.naveenb@cisco.com> <40F6BDC7.2090405@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:3803 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264571AbUGORmt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jul 2004 13:42:49 -0400
In-Reply-To: <40F6BDC7.2090405@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: naveenb@cisco.com
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:

> Naveen Burmi wrote:
> down to the driver to use scsi_scan_host_selected()? Or are you wanting 
> scsi_scan_host_selected() for your lun masking. I sent patches to kill 
> the latter and it will hopefully not exists in this lld in the near future.

Oh yeah the argument that you need the lun masking due to the lun limits 
is BS. I sent patches to fix this too.
