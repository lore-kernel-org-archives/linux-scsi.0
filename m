From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: remove scsi_to_u32
Date: Wed, 14 Jan 2015 11:49:02 +0100
Message-ID: <54B6499E.9080401@sandisk.com>
References: <1420884641-29518-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0065.outbound.protection.outlook.com ([157.56.111.65]:11218
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751540AbbANKtL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2015 05:49:11 -0500
In-Reply-To: <1420884641-29518-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 01/10/15 11:10, Christoph Hellwig wrote:
> scsi_to_u32 is a non-optimized reimplementation of get_unaligned_be32,
> just use the real thing (TM).

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

