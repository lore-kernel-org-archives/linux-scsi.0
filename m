From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/3] Add disk hotswap support to libata RESEND #5
Date: Wed, 28 Sep 2005 16:04:55 -0400
Message-ID: <433AF767.205@pobox.com>
References: <355e5e5e0509261801613c9bdb@mail.gmail.com>	 <433AE72B.1060708@pobox.com> <355e5e5e050928124651ba8947@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:64741 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750827AbVI1UFC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2005 16:05:02 -0400
In-Reply-To: <355e5e5e050928124651ba8947@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukasz Kosewski <lkosewsk@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Lukasz Kosewski wrote:
> No.  ata_device_add returns nonzero on success; so say the docs. 

Whoops, you're right.  I forget it was special.


> Since the return value is not checked here, and whether on success or
> failure all of the data structures allocated in that method stick
> around, I assumed that something was in the works for this.  I'll
> change this to kfree(hp) on returning 0.  Please advise if I should do
> something else.

It still needs to clean up after pdc_host_init()...

	Jeff


