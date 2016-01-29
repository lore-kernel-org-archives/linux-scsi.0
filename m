From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 2/2] megaraid_sas: Fix SMAP issue
Date: Fri, 29 Jan 2016 17:24:57 +0100
Message-ID: <56AB9259.9000905@redhat.com>
References: <1453995866-25097-1-git-send-email-sumit.saxena@avagotech.com>
 <1453995866-25097-3-git-send-email-sumit.saxena@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbcA2QZA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jan 2016 11:25:00 -0500
In-Reply-To: <1453995866-25097-3-git-send-email-sumit.saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com

On 28.1.2016 16:44, Sumit Saxena wrote:
> Inside compat IOCTL hook of driver, driver was using wrong address of
> ioc->frame.raw which leads sense_ioc_ptr to be calculated wrongly and
> failing IOCTL.
>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

