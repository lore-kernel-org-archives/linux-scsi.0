From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [OOPS] 2.6.11 - NMI lockup with CFQ scheduler
Date: Wed, 06 Apr 2005 14:52:10 +0200
Message-ID: <1112791930.6275.69.camel@laptopd505.fenrus.org>
References: <20050329122226.94666.qmail@web52902.mail.yahoo.com>
	 <20050329122635.GP16636@suse.de>  <20050406123147.GD9417@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38798 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262146AbVDFMwV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Apr 2005 08:52:21 -0400
In-Reply-To: <20050406123147.GD9417@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Chris Rankin <rankincj@yahoo.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> @@ -324,6 +334,7 @@
>  	issue_flush_fn		*issue_flush_fn;
>  	prepare_flush_fn	*prepare_flush_fn;
>  	end_flush_fn		*end_flush_fn;
> +	release_queue_data_fn	*release_queue_data_fn;
>  
>  	/*
>  	 * Auto-unplugging state

where does this function method actually get called?

