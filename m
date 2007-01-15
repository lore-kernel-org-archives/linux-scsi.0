From: "=?UTF-8?Q?Kristian_H=C3=B8gsberg?=" <krh@bitplanet.net>
Subject: Re: [PATCH] ieee1394: sbp2: remove bogus "emulated" host flag
Date: Mon, 15 Jan 2007 14:41:15 -0500
Message-ID: <59ad55d30701151141n72e3e99ey509d859c272b8bda@mail.gmail.com>
References: <tkrat.cd304ed480ae458e@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:23030 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbXAOTlW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jan 2007 14:41:22 -0500
Received: by ug-out-1314.google.com with SMTP id 44so1448977uga
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2007 11:41:17 -0800 (PST)
In-Reply-To: <tkrat.cd304ed480ae458e@s5r6.in-berlin.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On 1/14/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> There is no emulation going on here.
...

> -       .emulated                = 1,

Not sure what this flag does, but I copied it over to fw-sbp2.c.  If
it's bogus, I guess we should drop it from fw-sbp2.c too.

Kristian
