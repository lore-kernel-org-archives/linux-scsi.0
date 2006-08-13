From: Andrew Morton <akpm@osdl.org>
Subject: Re: Linux 2.6.17.6 Kernel Oops: kmem_cache_create: duplicate cache
 scsi_cmd_cache
Date: Sun, 13 Aug 2006 13:32:10 -0700
Message-ID: <20060813133210.8a2fe10d.akpm@osdl.org>
References: <Pine.LNX.4.64.0608131608460.20462@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:37545 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751416AbWHMUca (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Aug 2006 16:32:30 -0400
In-Reply-To: <Pine.LNX.4.64.0608131608460.20462@p34.internal.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, apiszcz@solarrain.com

On Sun, 13 Aug 2006 16:12:26 -0400 (EDT)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> Executing the following commands:
> 
> # --------------- #
> 
> rmmod sym53c8xx scsi_transport_spi st scsi_mod
> 
> modprobe scsi_mod
> modprobe st
> modprobe scsi_transport_spi
> modprobe sym53c8xx
> 
> scsiadd -s
> 
> # --------------- #
> 
> Then I got this, see dmesg below:
> 
> ...
>
> [4489213.171000] kmem_cache_create: duplicate cache scsi_cmd_cache

google("duplicate cache scsi_cmd_cache") indicates that this bug has been
present and known about for at least two and a half years.

