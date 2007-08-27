From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [RFC][PATCH] Removal of #include <linux/stat.h> from scsi drivers
Date: Tue, 28 Aug 2007 00:39:07 +0200
Message-ID: <6bffcb0e0708271539n3f82e53dq3d31079e943a9618@mail.gmail.com>
References: <46CB2865.3030103@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:9459 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbXH0WjJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Aug 2007 18:39:09 -0400
Received: by wa-out-1112.google.com with SMTP id v27so2273901wah
        for <linux-scsi@vger.kernel.org>; Mon, 27 Aug 2007 15:39:08 -0700 (PDT)
In-Reply-To: <46CB2865.3030103@googlemail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On 21/08/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Hi,
>
> This patch removes linux/stat.h from scsi drivers.
>
> Tested with allyesconfig and allmodconfig.
>

Any comments on this? ACK, NACK or "do not touch the SCSI code"?

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
