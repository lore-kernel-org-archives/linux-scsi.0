From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: fix sparse warnings
Date: Thu, 5 Feb 2015 12:38:55 +0100
Message-ID: <54D3564F.8000207@sandisk.com>
References: <1423129268-16220-1-git-send-email-prabhakar.csengg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0098.outbound.protection.outlook.com ([157.56.111.98]:57424
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752004AbbBELjD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2015 06:39:03 -0500
In-Reply-To: <1423129268-16220-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lad Prabhakar <prabhakar.csengg@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

On 02/05/15 10:41, Lad Prabhakar wrote:
> this patch fixes following sparse warnings:
> scsi_sysfs.c:201:25: warning: symbol 'dev_attr_hstate' was not declared. Should it be static?
> scsi_sysfs.c:376:24: warning: symbol 'scsi_shost_attr_group' was not declared. Should it be static?

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
