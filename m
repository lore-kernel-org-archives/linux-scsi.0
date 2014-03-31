From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/4] scsi: remove scsi_end_request
Date: Sun, 30 Mar 2014 22:26:10 -0700
Message-ID: <1396243570.22255.35.camel@haakon3.risingtidesystems.com>
References: <1395936862-6938-1-git-send-email-hch@lst.de>
	 <1395936862-6938-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59550 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaCaF0X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2014 01:26:23 -0400
In-Reply-To: <1395936862-6938-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

Hi hch & jejb,

On Thu, 2014-03-27 at 17:14 +0100, Christoph Hellwig wrote:
> Simply the I/O completion logic by folding scsi_end_request into its only
> caller.  There is a single site to either requeue the command or move on
> to the next one instead of of the previous convoluted logic.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_lib.c |  114 +++++++++++++----------------------------------
>  1 file changed, 32 insertions(+), 82 deletions(-)
> 

Looks like a reasonable simplification.

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>


