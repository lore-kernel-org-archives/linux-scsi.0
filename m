From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] add driver for DesignWare UFS Host Controller
Date: Fri, 8 Jan 2016 23:20:00 +0900
Message-ID: <CAC5umyg=vhQ_5Nz60u8gsZFEOFP45cmXnSGny-v4ddk4qNeMHA@mail.gmail.com>
References: <c6de799a23c6626b95ccdcb89ba0b2341b441fa0.1450293353.git.jpinto@synopsys.com>
	<20160107094437.GA11038@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:36611 "EHLO
	mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbcAHOUC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2016 09:20:02 -0500
Received: by mail-vk0-f54.google.com with SMTP id n1so37823646vkb.3
        for <linux-scsi@vger.kernel.org>; Fri, 08 Jan 2016 06:20:01 -0800 (PST)
In-Reply-To: <20160107094437.GA11038@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Joao Pinto <Joao.Pinto@synopsys.com>, Yaniv Gardi <ygardi@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, CARLOS.PALMINHA@synopsys.com

2016-01-07 18:44 GMT+09:00 Christoph Hellwig <hch@infradead.org>:
>> This driver patch includes a core driver and glue drivers for pci and platform
>> for the DesignWare UFS Host IP.
>
> Why doesn't this use the existing ufs core?  The architecture looks
> completely backwards to me.

I agree.  The existing ufs driver can have variant specific operations
(hba->vops) and also can define quirks.  So if DesignWare UFS host
controller requires vendor specific register settings or DME operations
in initialization, or needs special workarounds for the specific versions,
it can use those mechanisms and shares common parts between other host
controllers.
