From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v4] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Tue, 14 Jun 2016 10:09:05 +0200
Message-ID: <9680e172-4646-1cfc-fbc8-5b47a168040b@sandisk.com>
References: <1464409675.22249.237.camel@haakon3.risingtidesystems.com>
 <1465507614-29695-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0073.outbound.protection.outlook.com ([65.55.169.73]:10880
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750703AbcFNIJT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2016 04:09:19 -0400
In-Reply-To: <1465507614-29695-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, nab@linux-iscsi.org, hch@infradead.org
Cc: mikecyr@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, joe@perches.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com

On 06/09/2016 11:26 PM, Bryant G. Ly wrote:
> This driver is a pick up of the old IBM VIO scsi Target Driver
> that was started by Nick and Fujita 2-4 years ago.
> http://comments.gmane.org/gmane.linux.scsi/90119

What kernel version is this patch based on? It doesn't apply cleanly on 
top of kernel v4.7-rc1 nor on top of kernel v4.6.

Thanks,

Bart.
