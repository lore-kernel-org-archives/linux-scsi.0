From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH]:Amended:Allow random write for PDT 5 profile 2
	Removabl e Disk
Date: 08 Mar 2004 13:01:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1078776081.2341.168.camel@patibmrh9>
References: <1078769250.7104.15.camel@lintest.iomegacorp.com>
	 <20040308192011.GG23525@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:54662 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261169AbUCHUD1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Mar 2004 15:03:27 -0500
In-Reply-To: <20040308192011.GG23525@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: John McKell <mckellj@iomega.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

// Jens A et al.:

Cogent, thank you, I now have new guesses of how I can help here.

// John M:

> > Feel free to resend.

If you choose to resend when kernel.org releases 2.6.4 ...

> +++ linux/include/linux/cdrom.h
> ...
> -#define CDF_MRW 0x28
> +#define CDF_RWRT 0x0020
> +#define CDF_HWDM 0x0024
> +#define CDF_MRW 0x0028

Then please consider linking this t10.org hex with the t10.org English:

-#define CDF_MRW 0x28
+#define CDF_RWRT 0x0020 /* "Random Writable" */
+#define CDF_HWDM 0x0024 /* "Hardware Defect Management" */
+#define CDF_MRW 0x0028

With those two comments added, I no longer trip at first glance over the
inscrutable RT of R W RT in the source (run time? real time? rather
'tochastic?) instead I see the R Wrt that I now imagine we intend.

Pat LaVarre

P.S. MRW I left unelaborated because MRW appears as "MRW" at t10.org


