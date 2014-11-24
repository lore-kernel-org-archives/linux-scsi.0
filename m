From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] libsas: remove task_collector mode
Date: Mon, 24 Nov 2014 08:46:22 -0800
Message-ID: <CAPcyv4ij4P4TAdSvk1Z_NcSSK-E6phj-EWqYanZd_4a+fh9ACg@mail.gmail.com>
References: <1416818502-19584-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:55479 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbaKXQqX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 11:46:23 -0500
Received: by mail-wg0-f41.google.com with SMTP id y19so12821857wgg.0
        for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2014 08:46:22 -0800 (PST)
In-Reply-To: <1416818502-19584-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Chen Gang <gang.chen.5i5j@gmail.com>, James Bottomley <JBottomley@parallels.com>

On Mon, Nov 24, 2014 at 12:41 AM, Christoph Hellwig <hch@lst.de> wrote:
> The task_collector mode (or "latency_injector", (C) Dan Willians) is an
> optional I/O path in libsas that queues up scsi commands instead of
> directly sending it to the hardware.  It generall increases latencies
> to in the optiomal case slightly reduce mmio traffic to the hardware.
>
> Only the obsolete aic94xx driver and the mvsas driver allowed to use
> it without recompiling the kernel, and most drivers didn't support it
> at all.
>
> Remove the giant blob of code to allow better optimizations for scsi-mq
> in the future.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Dan Williams <dan.j.williams@intel.com>
