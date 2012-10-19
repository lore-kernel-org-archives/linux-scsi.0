From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/1] aacraid: SCSI dma mapping failure case handling
Date: Fri, 19 Oct 2012 16:30:21 +0200
Message-ID: <508163FD.506@redhat.com>
References: <1350654667-2304-1-git-send-email-Mahesh_Rajashekhara@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030393Ab2JSOaz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Oct 2012 10:30:55 -0400
In-Reply-To: <1350654667-2304-1-git-send-email-Mahesh_Rajashekhara@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>
Cc: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, aacraid@pmc-sierra.com, Achim_Leubner@pmc-sierra.com, Tony_Ruiz@pmc-sierra.com

On 10/19/2012 03:51 PM, Mahesh Rajashekhara wrote:
> Hi James,
>
> We've incorporated the changes suggested by Tomas in this driver patch.  I would request you to please consider this patch. Please let us know your comments if any.
>
> Patch Description:
> This patch handles SCSI dma mapping failure case. Reporting error code to the upper layer instead of BUG_ON().
>
> Signed-off-by: Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>

Acked-by: Tomas Henzl <thenzl@redhat.com>

Thanks.

