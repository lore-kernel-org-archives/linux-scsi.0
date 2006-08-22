From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Patch] cleanup: GFP_ATOMIC to GFP_KERNEL in scsi_scan.c
Date: Tue, 22 Aug 2006 22:26:20 +0200
Message-ID: <44EB686C.3080908@s5r6.in-berlin.de>
References: <1156187273.2924.12.camel@dyn-9-152-230-71.boeblingen.de.ibm.com> <44EAD1B7.1010505@s5r6.in-berlin.de> <44EB267A.7010104@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41662 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932099AbWHVU2v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Aug 2006 16:28:51 -0400
In-Reply-To: <44EB267A.7010104@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mp3@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

Martin Peschke wrote:
> My changes conform to this description, as far as scsi_mid_low_api.txt
> covers the interfaces touched by my patch.
> 
> Looks like a documentation update is needed regardless of my patch:
[...scsi_get_host_dev, scsi_scan_target, __scsi_add_device, 
scsi_add_host, scsi_host_get,...]

Thanks a lot for taking the time to clarify this.
-- 
Stefan Richter
-=====-=-==- =--- =-==-
http://arcgraph.de/sr/
