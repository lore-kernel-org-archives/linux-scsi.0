From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Subject: Re: [patch 1/2] zfcp: Update MAINTAINERS entry
Date: Thu, 01 Apr 2010 13:42:43 +0200
Message-ID: <1270122163.4902.1.camel@kitka>
References: <20100401110406.973537000@de.ibm.com>
	 <20100401110549.849117000@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:45312 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab0DALmp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2010 07:42:45 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate1.uk.ibm.com (8.13.1/8.13.1) with ESMTP id o31BgixU027644
	for <linux-scsi@vger.kernel.org>; Thu, 1 Apr 2010 11:42:44 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o31BgiYk880730
	for <linux-scsi@vger.kernel.org>; Thu, 1 Apr 2010 12:42:44 +0100
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o31Bghnp010139
	for <linux-scsi@vger.kernel.org>; Thu, 1 Apr 2010 12:42:44 +0100
In-Reply-To: <20100401110549.849117000@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>

confirmed

Cheers,
Martin

On Thu, 2010-04-01 at 13:04 +0200, Christof Schmitt wrote:
> plain text document attachment (700-zfcp-update-maintainers.diff)
> From: Christof Schmitt <christof.schmitt@de.ibm.com>
> 
> Martin no longer works on zfcp, remove his entry from the MAINTAINERS
> file and add Swen as co-maintainer.
> 
> Also remove the reference to the zfcpdump.txt file, zfcpdump is not
> part of the zfcp device driver.
> 
> Cc: Martin Peschke <mp3@de.ibm.com>
> Cc: Swen Schillig <swen@vnet.ibm.com>
> Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
> ---
> 
>  MAINTAINERS |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- a/MAINTAINERS	2010-04-01 12:17:08.000000000 +0200
> +++ b/MAINTAINERS	2010-04-01 12:22:54.000000000 +0200
> @@ -4776,12 +4776,11 @@ F:	drivers/s390/crypto/
> 
>  S390 ZFCP DRIVER
>  M:	Christof Schmitt <christof.schmitt@de.ibm.com>
> -M:	Martin Peschke <mp3@de.ibm.com>
> +M:	Swen Schillig <swen@vnet.ibm.com>
>  M:	linux390@de.ibm.com
>  L:	linux-s390@vger.kernel.org
>  W:	http://www.ibm.com/developerworks/linux/linux390/
>  S:	Supported
> -F:	Documentation/s390/zfcpdump.txt
>  F:	drivers/s390/scsi/zfcp_*
> 
>  S390 IUCV NETWORK LAYER
> 

