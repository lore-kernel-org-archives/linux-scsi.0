From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 06/15] megaraid_sas: Fastpath region lock bypass
Date: Tue, 12 Jan 2016 15:44:02 +0100
Message-ID: <56951132.2030104@redhat.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
 <1450445228-26571-7-git-send-email-Sumit.Saxena@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbcALOoE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2016 09:44:04 -0500
In-Reply-To: <1450445228-26571-7-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com

On 18.12.2015 14:26, Sumit Saxena wrote:
> Firmware will fill per LD data to tell driver that particular LD supports Region lock bypass or not. If yes, then 
> Driver will send non FP LDIO to region lock bypass FIFO. With this change in driver, firmware will optimize certain
> code to improve performance.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

