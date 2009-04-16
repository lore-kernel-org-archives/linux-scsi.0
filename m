From: James Smart <James.Smart@Emulex.Com>
Subject: Re: queue_depth tracking from LLD
Date: Thu, 16 Apr 2009 11:32:41 -0400
Message-ID: <49E74F99.7090203@emulex.com>
References: <20090416093604.GA7096@schmichrtp.de.ibm.com> <49E73D16.9030307@emulex.com> <49E74058.5010401@cs.wisc.edu> <49E742CE.3020302@emulex.com> <20090416152707.GA18972@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:38007 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbZDPPdw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2009 11:33:52 -0400
In-Reply-To: <20090416152707.GA18972@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



Christof Schmitt wrote:
> zfcp is one of the drivers that don't have ramp-up/down mechanism in
> place. And i am trying to understand what is required here.  Is there
> currently work being done to get queue_depth ramp-up/down in the
> midlayer?

No work started - but desired.

I'd recommend, rather than implementing it in zfcp, implement it in the
midlayer for everyone.

> 
>>> If we moved code like that to the scsi layer, then is all the is needed 
>>> is a interface to config this?
> 
>> Yep. As mentioned, figuring out what algorithm, for what device and
>> configuration, will be the more interesting thing.
> 
> If the LLDs that currently have a private ramp-up/down mechanism in
> place use a similar strategy, would it make sense to first move them
> to common code that can be activated from a LLD? And later refine it
> with device-specific behaviour?

Yes.

-- james s
