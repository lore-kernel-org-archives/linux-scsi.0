From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 08/15] megaraid_sas: Code optimization build_and_issue_cmd
 return-type
Date: Thu, 14 Jan 2016 19:05:17 +0100
Message-ID: <5697E35D.60507@redhat.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
 <1450445228-26571-9-git-send-email-Sumit.Saxena@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbcANSFT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jan 2016 13:05:19 -0500
In-Reply-To: <1450445228-26571-9-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com

On 18.12.2015 14:27, Sumit Saxena wrote:
> build_and_issue_cmd should return SCSI_MLQUEUE_HOST_BUSY for few error case instead of returning 1.
>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

