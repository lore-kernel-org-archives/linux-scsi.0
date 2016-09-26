From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 2/3] g_NCR5380: Reduce overrides[] from array to struct
Date: Mon, 26 Sep 2016 13:56:04 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1609261127530.4836@nippy.intranet>
References: <1474743545-4731-1-git-send-email-linux@rainbow-software.org> <1474743545-4731-3-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:34056 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941326AbcIZDzv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Sep 2016 23:55:51 -0400
In-Reply-To: <1474743545-4731-3-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


On Sat, 24 Sep 2016, Ondrej Zary wrote:

> Remove compile-time card type definition GENERIC_NCR5380_OVERRIDE. Then 
> remove all code iterating the overrides[] array and reduce it to struct 
> card.

There is a reference to the compile-time override in 
Documentation/scsi/g_NCR5380.txt which needs to be removed also.

The patch looks fine aside from that.

-- 
