From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [2.6 patch] let AIC7{9,X}XX_BUILD_FIRMWARE depend on !PREVENT_FIRMWARE_BUILD
Date: Tue, 03 Aug 2004 10:47:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <410FA577.4040602@adaptec.com>
References: <20040801185543.GB2746@fs.tum.de> <20040801191118.GA7402@mars.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:18411 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266580AbUHCOrl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2004 10:47:41 -0400
In-Reply-To: <20040801191118.GA7402@mars.ravnborg.org>
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, Adrian Bunk <bunk@fs.tum.de>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Sam,

You can forward it to Linus and I'll also integrate it
to the latest version of the drivers, yet to be integrated
to the mainline kernel.

Thanks!

Sam Ravnborg wrote:
> On Sun, Aug 01, 2004 at 08:55:44PM +0200, Adrian Bunk wrote:
>  >
>  > The patch below lets AIC7{9,X}XX_BUILD_FIRMWARE depend on
>  > !PREVENT_FIRMWARE_BUILD.
> 
> Justin, I agree with this change. Please let me know if I shall forward
> the patch to Linus, or you will take care.
> 
>         Sam
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Luben


