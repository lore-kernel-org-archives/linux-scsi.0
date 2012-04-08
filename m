From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 2/2] [SCSI] ufs: calculate read/write xfer len from cdb
Date: Sun, 8 Apr 2012 16:46:43 +0900
Message-ID: <CAKYAXd_EMj29Zu62MpnLPBZwTY7O6BB9UbqF6EoOzhv=KHgQAg@mail.gmail.com>
References: <1333715241-32346-1-git-send-email-santoshsy@gmail.com>
	<1333715241-32346-2-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65287 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab2DHHqo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Apr 2012 03:46:44 -0400
Received: by iagz16 with SMTP id z16so4730455iag.19
        for <linux-scsi@vger.kernel.org>; Sun, 08 Apr 2012 00:46:43 -0700 (PDT)
In-Reply-To: <1333715241-32346-2-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, yoshitake.kobayashi@toshiba.co.jp, vinholikatti@gmail.com

2012/4/6 Santosh Y <santoshsy@gmail.com>:
> Currently the Expected data transfer length field in
> command UPIU is being updated with "transfersize" from
> the scsi_cmnd struct. But, if the read/write data
> transfer size exceeds the sector size, the "transfersize"
> will be truncated to the sector size. Thanks to KOBAYASHI
> Yoshitake for pointing it out.
>
> This patch ensures that the correct read/write data transfer
> size is calculated from the "transfer length" available in the
> CDB.
>
> Reported-by: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
> Reviewed-by: Vinayak Holikatti <vinholikatti@gmail.com>
> Signed-off-by: Santosh Y <santoshsy@gmail.com>

Hi Santosh.
The specific decription header of this patch is very good.
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>

> ---
