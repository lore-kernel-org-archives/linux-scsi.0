From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] megaraid: fix null pointer check in megasas_detach_one().
Date: Thu, 4 Feb 2016 16:12:59 +0100
Message-ID: <56B36A7B.4@redhat.com>
References: <1453466502-9335-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965139AbcBDPND (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Feb 2016 10:13:03 -0500
In-Reply-To: <1453466502-9335-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>, sumit.saxena@avagotech.com
Cc: kashyap.desai@avagotech.com, uday.lingala@avagotech.com, linux-scsi@vger.kernel.org, jbottomley@parallels.com

On 22.1.2016 13:41, Maurizio Lombardi wrote:
> The pd_seq_sync pointer can't be NULL, we have to check
> its entries instead.
>
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

