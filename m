From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/8] firewire: ieee1394: Move away from SG_ALL
Date: Thu, 17 Jan 2008 18:51:18 +0100
Message-ID: <478F9596.1020509@s5r6.in-berlin.de>
References: <478F8435.5000907@panasas.com> <478F854B.2030302@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:54640 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYAQRwa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 12:52:30 -0500
In-Reply-To: <478F854B.2030302@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
>   SG_ALL wants to be ~0 meaning "any future size".
>   Below group of drivers preallocate a scatter list
>   buffer of max_size, so set that size to be 255 (Like before).
> 
>   A better schema can be advised with a more dynamic allocation.
>   Perhaps from a kmem_cache.
> 
>   List of drivers/files:
> 	drivers/firewire/fw-sbp2.c
> 	drivers/ieee1394/sbp2.[ch]
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

> ---
>  drivers/firewire/fw-sbp2.c |    6 ++++--
>  drivers/ieee1394/sbp2.c    |    2 +-
>  drivers/ieee1394/sbp2.h    |    4 +++-
>  3 files changed, 8 insertions(+), 4 deletions(-)

Since I wasn't Cc'd, I suppose you don't want me to take it upstream via
linux1394-2.6.git?

My guess is that there won't be conflicts of this with linux1394-2.6.git
anytime soon, so taking it into any other tree should be fine.
-- 
Stefan Richter
-=====-==--- ---= =---=
http://arcgraph.de/sr/
