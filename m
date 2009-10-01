From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: Fibre Channel pass-through for sending arbitrary FC and SCSI
 commands
Date: Wed, 30 Sep 2009 23:35:49 -0700
Message-ID: <4AC44DC5.4060106@cisco.com>
References: <da0ca6030909302225g6009092bh960a2e09f2cdeadd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:33850 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbZJAGfq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 02:35:46 -0400
In-Reply-To: <da0ca6030909302225g6009092bh960a2e09f2cdeadd@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: G S <gogman69-linuxscsi@yahoo.com>
Cc: linux-scsi@vger.kernel.org



G S wrote:
> Howdy,
> 
> The Linux "sg" (SCSI pass-through) can be used to send arbitrary SCSI
> commands to SCSI target devices.
> 
> But "sg" doesn't give me access to the transport layer details, such
> as constructing my own FCP_CMND and receiving FCP_RSP IU's.
> 
> Is there FC pass-thru in Linux (2.6) SCSI stack, that allows me to
> construct my own transport frames and payloads?

There's /dev/bsg* that gives lets you send ELS and CT frames, but not
just any FC frames.   You need to configure it under the "Block layer"
kconfig menu.  And perhaps not all HBAs support it.   See source
block/bsg.c for details.

> If not, is there vendor (eg. QLogic and Emulex) provided IOCTL module
> that allows application to interface directly to the HBA driver for
> doing FC pass-through?

I don't know that.

	Joe
