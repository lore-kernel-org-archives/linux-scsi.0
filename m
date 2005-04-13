From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi/a100u2w: Remove custom msecs_to_jiffies and jiffies_to_msecs macros
Date: Wed, 13 Apr 2005 15:43:08 +0100
Message-ID: <20050413144308.GA9616@infradead.org>
References: <20050413121104.GA9419@argon.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:2006 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261376AbVDMOnQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 10:43:16 -0400
Content-Disposition: inline
In-Reply-To: <20050413121104.GA9419@argon.tklauser.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tobias Klauser <tklauser@nuerscht.ch>
Cc: kernel-janitors@lists.osdl.org, linux-scsi@vger.kernel.org

>  static void waitForPause(unsigned amount)
>  {
> -	ULONG the_time = jiffies + MS_TO_JIFFIES(amount);
> +	ULONG the_time = jiffies + msecs_to_jiffies(amount);
>  	while (time_before_eq(jiffies, the_time))
>  		cpu_relax();

You should probably replace this function with msleep completely.
