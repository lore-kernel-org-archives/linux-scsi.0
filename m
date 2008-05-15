From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 0/7] scsi_dh framework update
Date: Wed, 14 May 2008 19:45:40 -0700
Message-ID: <1210819540.21974.250.camel@chandra-ubuntu>
References: <482AFA62.2000506@suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41500 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742AbYEOCoB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2008 22:44:01 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4F2hwaL016132
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2008 22:43:58 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4F2hwBD146358
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2008 22:43:58 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4F2hvmf027406
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2008 22:43:58 -0400
In-Reply-To: <482AFA62.2000506@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dm-devel <dm-devel@redhat.com>

Hi Hannes,

Thanks for the clean up and the new features. I have reviewed the code
but hasn't tested it. Comments follow.

BTW, checkpatch.pl generates warnings for patches 1 thru 5.

regards,

chandra
On Wed, 2008-05-14 at 16:42 +0200, Hannes Reinecke wrote:
> Hi James,
> 
> this is a repost of my patchset to update the scsi_dh infrastructure.
> 
> It's based on the current scsi-misc tree.
> 
> Main features of the patchset are:
> - Use a single callback for the notifier chain
> - Merge all device maps into a single list,
>   which will be scanned by a generic function
> - Add a sysfs attribute 'dh_state' for each sdev
> - Add a generic SPC-3 ALUA device handler
> - Update device handlers to check if the
>   device actually supports this handler.
>   When attaching manually we are able to attach
>   to basically any device, so we have to make sure
>   that the device handler is actually supported.
> - Manually attach a device when a hardware handler
>   is specified; this allows multipath to override
>   the built-in hardware table.
> 
> As per usual, comment etc are welcome.
> 
> Cheers,
> 
> Hannes

