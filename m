From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/6] [SCSI] Look up and store NAA if VPD page 0x83 is
 present
Date: Mon, 02 Jun 2014 13:43:29 -0700
Message-ID: <1401741809.32085.5.camel@haakon3.risingtidesystems.com>
References: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
	 <1401335565-29865-6-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45435 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbaFBUna (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 16:43:30 -0400
In-Reply-To: <1401335565-29865-6-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

On Wed, 2014-05-28 at 23:52 -0400, Martin K. Petersen wrote:
> Copy offloading requires us to know the NAA descriptor for both source
> target device. This descriptor is mandatory in the Device Identification
> VPD page. Locate this descriptor in the returned VPD data so we don't
> have to do lookups for every copy command.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/scsi/scsi.c        | 57 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/scsi/scsi_device.h |  2 ++
>  2 files changed, 59 insertions(+)
> 

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>

