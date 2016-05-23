From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] sd: Fix rw_max for devices that report an optimal xfer
 size
Date: Mon, 23 May 2016 08:58:58 -0700
Message-ID: <ff202349-11a0-83a7-980d-e5678d5e9762@sandisk.com>
References: <1463714194-14258-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0086.outbound.protection.outlook.com ([65.55.169.86]:29504
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753012AbcEWQOp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2016 12:14:45 -0400
In-Reply-To: <1463714194-14258-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 05/19/2016 08:16 PM, Martin K. Petersen wrote:
> For historic reasons, io_opt is in bytes and max_sectors in block layer
> sectors. This interface inconsistency is error prone and should be
> fixed. But for 4.4--4.7 let's make the unit difference explicit via a
> wrapper function.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
