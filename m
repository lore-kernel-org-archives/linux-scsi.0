From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] sg: remove the own list management for struct sg_fd
Date: Mon, 16 Feb 2009 11:19:08 +0100
Message-ID: <49993D9C.3020005@interlog.com>
References: <20090216132630B.fujita.tomonori@lab.ntt.co.jp>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56490 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbZBPKTU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Feb 2009 05:19:20 -0500
In-Reply-To: <20090216132630B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> This replaces the own list management for struct sg_fd with the
> standard list_head structure.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
