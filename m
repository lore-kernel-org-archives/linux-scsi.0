From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] SCSI: misc possible cleanups
Date: Mon, 15 Nov 2004 17:22:32 +0100
Message-ID: <20041115162232.GA19860@stusta.de>
References: <0B1E13B586976742A7599D71A6AC733C12E6F2@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43781 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261630AbUKOQ2N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 11:28:13 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12E6F2@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 15, 2004 at 08:57:08AM -0500, James.Smart@Emulex.Com wrote:

> Please don't back out the additions to scsi_transport.c!!!
> 
> These were hard-fought additions, and required by our driver, which we should call for upstream approval in the near future.

Sorry that I didn't state my intention clear enough:

I did not want to propose to simply apply this patch.
It was intended as a "FYI: the following code is _currently_ unused".

> -- James S

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

