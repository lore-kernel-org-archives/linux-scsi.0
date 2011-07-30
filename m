From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 9/9] isci: add version number
Date: Sat, 30 Jul 2011 18:55:07 +0200
Message-ID: <20110730185507.7b68c0a7@stein>
References: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
	<20110730001721.28430.28086.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:42904 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab1G3Q4H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jul 2011 12:56:07 -0400
In-Reply-To: <20110730001721.28430.28086.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org

On Jul 29 Dan Williams wrote:
> @@ -540,7 +548,8 @@ static __init int isci_init(void)
>  {
>  	int err;
>  
> -	pr_info("%s: Intel(R) C600 SAS Controller Driver\n", DRV_NAME);
> +	pr_info("%s: Intel(R) C600 SAS Controller Driver - version %s\n",
> +		DRV_NAME, DRV_VERSION);

Why?  There is already a version number.  Like 2.6.39, 3.0, 3.1.

Besides, just

-	pr_info("%s: Intel(R) C600 SAS Controller Driver\n", DRV_NAME);

would be the most correct thing to do here.
-- 
Stefan Richter
-=====-==-== -=== ====-
http://arcgraph.de/sr/
