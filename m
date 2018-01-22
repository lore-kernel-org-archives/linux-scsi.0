From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] scsi: remove extra white space at the end of the line
Date: Tue, 23 Jan 2018 00:41:02 +0100
Message-ID: <2f6e0605-86cb-3f90-96a1-7d1f90871712@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:43176 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbeAVXlF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2018 18:41:05 -0500
Received: by mail-wr0-f181.google.com with SMTP id t16so10537361wrc.10
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2018 15:41:04 -0800 (PST)
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, linux-scsi <linux-scsi@vger.kernel.org>

Jason Yan wrote:

> My editor always try to remove the extra white space at the end of the
> line when I make some changes. I'm tired of adjusting them manually.

A real (trailing) clean up is done with:
find -type f -exec sed -i 's/[[:cntrl:]]\+$//' {} +

Trailing spaces, tabs and ^L were deleted from drivers/scsi.
There is crap in the whole linux tree.
