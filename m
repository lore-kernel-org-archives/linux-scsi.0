From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] scsi: arm: fas216: Use %llu to print 'u64' format
Date: Fri, 11 Jul 2014 08:31:29 -0300
Message-ID: <CAOMZO5BVmWocr8CaR5VaODpLcNH5-9sibwPDx9MCmmLtDg=Q=Q@mail.gmail.com>
References: <1405035187-27737-1-git-send-email-festevam@gmail.com>
	<20140711062302.GA12385@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:52351 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaGKLba (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jul 2014 07:31:30 -0400
Received: by mail-lb0-f173.google.com with SMTP id v6so528929lbi.18
        for <linux-scsi@vger.kernel.org>; Fri, 11 Jul 2014 04:31:29 -0700 (PDT)
In-Reply-To: <20140711062302.GA12385@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>

Hi Christoph,

On Fri, Jul 11, 2014 at 3:23 AM, Christoph Hellwig <hch@infradead.org> wrote:
> Thanks Fabio,
>
> this looks good to me.  Are there any other warnings you got from that
> autobuilder?

Yes, the build results for various ARM defconfigs are available at:
http://lists.linaro.org/pipermail/kernel-build-reports/2014-July/004338.html

Regards,

Fabio Estevam
