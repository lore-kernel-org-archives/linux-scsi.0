From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] SCSI: make pcmcia directory use obj-y|m instead of subdir-y|m
Date: Sat, 08 Dec 2007 07:35:01 +0900
Message-ID: <4759CA95.4070905@gmail.com>
References: <47594C57.4070006@gmail.com> <20071207160603.GB31641@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:42922 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbXLGWfL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2007 17:35:11 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1738688wah
        for <linux-scsi@vger.kernel.org>; Fri, 07 Dec 2007 14:35:09 -0800 (PST)
In-Reply-To: <20071207160603.GB31641@uranus.ravnborg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Sam Ravnborg wrote:
> On Fri, Dec 07, 2007 at 10:36:23PM +0900, Tejun Heo wrote:
>> subdir-y|m isn't supposed to contain modules or built-in components.
>> Change subdir-$(CONFIG_PCMCIA) to obj-$(CONFIG_PCMCIA).
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>> Cc: Sam Ravnborg <sam@ravnborg.org>
>> Cc: James Bottomley <James.Bottomley@SteelEye.com>
> Ack-by: Sam Ravnborg <sam@ravnborg.org>

Thanks.  I guess this should go through SCSI tree.  James, can you
please forward this upstream?

-- 
tejun
