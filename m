From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] Fix up tag usage in lpfc
Date: Fri, 19 Oct 2007 08:58:17 -0400
Message-ID: <4718A9E9.1090608@emulex.com>
References: <20071018101212.GC22562@pentland.suse.de>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39353 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762146AbXJSM6V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2007 08:58:21 -0400
In-Reply-To: <20071018101212.GC22562@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

Yep, this was an oversight... In looking through it though, there are
some additional things that should be checked. We're about to post our
next set of patches, so I'll include this fix with them.

thanks.

-- james s

Hannes Reinecke wrote:
> Hi James,
> 
> appearently the lpfc driver is sligtly confused about the meaning
> of the 'scmd->tag' value. It should rather inspect the correct
> flags to detect the proper SCSI Tag value.
> 
> Cheers,
> 
> Hannes
> 
