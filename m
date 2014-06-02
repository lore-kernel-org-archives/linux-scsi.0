From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/6] block: Copy offload ioctl
Date: Mon, 02 Jun 2014 13:42:21 -0700
Message-ID: <1401741741.32085.4.camel@haakon3.risingtidesystems.com>
References: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
	 <1401335565-29865-5-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48651 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaFBUmW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 16:42:22 -0400
In-Reply-To: <1401335565-29865-5-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

On Wed, 2014-05-28 at 23:52 -0400, Martin K. Petersen wrote:
> Add an ioctl which can be used to clone a block range within a single
> block device. This is useful for testing the copy offload code.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  block/ioctl.c           | 35 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/fs.h |  1 +
>  2 files changed, 36 insertions(+)
> 

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>

