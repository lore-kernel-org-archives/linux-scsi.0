From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 0/7] scsi_dh framework update take #2
Date: Thu, 22 May 2008 19:08:10 -0700
Message-ID: <1211508490.21974.500.camel@chandra-ubuntu>
References: <4832DA6B.3050702@suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:45741 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045AbYEWCGK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2008 22:06:10 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4N26300026607
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2008 22:06:03 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4N263da091608
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2008 20:06:03 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4N262CH027900
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2008 20:06:03 -0600
In-Reply-To: <4832DA6B.3050702@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

Hi Hannes,

I looked at the patches except 3, 4 and 5 (as I don't have context
knowledge).

Thanks,

chandra
On Tue, 2008-05-20 at 16:04 +0200, Hannes Reinecke wrote:
> Hi James,
> 
> this is the second repost of my patchset to update the scsi_dh
> infrastructure. It includes the comments by Chandra.
> 
> It's based on the current scsi-misc tree.
> 
> Main features of the patchset are:
> - Use a single callback for the notifier chain
> - Merge all device maps into a single list,
>  which will be scanned by a generic function
> - Add a sysfs attribute 'dh_state' for each sdev
> - Add a generic SPC-3 ALUA device handler
> - Update device handlers to check if the
>  device actually supports this handler.
>  When attaching manually we are able to attach
>  to basically any device, so we have to make sure
>  that the device handler is actually supported.
> - Manually attach a device when a hardware handler
>  is specified; this allows multipath to override
>  the built-in hardware table.
> - Update dm-multipath to explicitly attach to
>  the specified device handler. This allows
>  overriding of the built-in table by the
>  multipath values.
> 
> As per usual, comment etc are welcome.
> 
> Cheers,
> 
> Hannes

