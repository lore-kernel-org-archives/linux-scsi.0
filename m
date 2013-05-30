From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/5] scsi: use platform helper macro and wrapper
 functions
Date: Thu, 30 May 2013 07:38:19 -0700
Message-ID: <1369924699.1972.4.camel@dabdike.int.hansenpartnership.com>
References: <1369915786-2660-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57819 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932636Ab3E3OiW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 May 2013 10:38:22 -0400
In-Reply-To: <1369915786-2660-1-git-send-email-wangkefeng.wang@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, guohanjun@huawei.com

On Thu, 2013-05-30 at 20:09 +0800, Kefeng Wang wrote:
> use module_platform_driver() and paltform{set,get}_drvdata to simpily code,
> and patch 2/5 delete unnecessery drvdate set to null.
> 
> Kefeng Wang (5):
>   scsi: jazz: use module_platform_driver() and
>     platform_{set,get}_drvdata
>   scsi: sun: use module_platform_driver() and platform_{set,get}_drvdata
>   scsi: qlogicpti: use module_platform_driver() and
>     platform_{set,get}_drvdata
>   scsi: sun3x: use module_platform_driver() and
>     platform_{set,get}_drvdata
>   scsi: sni: use module_platform_driver() and platform_{set,get}_drvdata
> 
>  drivers/scsi/jazz_esp.c   | 17 +++--------------
>  drivers/scsi/qlogicpti.c  | 17 +++--------------
>  drivers/scsi/sni_53c710.c | 17 +++--------------
>  drivers/scsi/sun3x_esp.c  | 16 +++-------------
>  drivers/scsi/sun_esp.c    | 19 +++----------------
>  5 files changed, 15 insertions(+), 71 deletions(-)

There doesn't seem to be much point to these patches since either idiom
is fine and easily understood.  We also try to touch the ancient drivers
as little as possible since it can be months before anyone actually
tries them out and notices that something got broken, so the rule for
them is obvious bug fixes only.

James


