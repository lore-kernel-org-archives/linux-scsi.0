From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: queue_depth tracking from LLD
Date: Thu, 16 Apr 2009 17:27:07 +0200
Message-ID: <20090416152707.GA18972@schmichrtp.de.ibm.com>
References: <20090416093604.GA7096@schmichrtp.de.ibm.com> <49E73D16.9030307@emulex.com> <49E74058.5010401@cs.wisc.edu> <49E742CE.3020302@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:37476 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZDPP1K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2009 11:27:10 -0400
Received: from d06nrmr1806.portsmouth.uk.ibm.com (d06nrmr1806.portsmouth.uk.ibm.com [9.149.39.193])
	by mtagate3.uk.ibm.com (8.14.3/8.13.8) with ESMTP id n3GFR82e240750
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 15:27:08 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3GFR8103342540
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 16:27:08 +0100
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3GFR8gJ026176
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 16:27:08 +0100
Content-Disposition: inline
In-Reply-To: <49E742CE.3020302@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Apr 16, 2009 at 10:38:06AM -0400, James Smart wrote:
> Mike Christie wrote:
[...]
> No good reason.  It should be in the midlayer, and that was the
> recommendation I made at storage summit a couple of years ago. It
> hasn't as, for the drivers that  care, they had already implemented
> it. It also isn't a relished task, as there will be lots of
> discussion on how the ramp-up should be implemented - which may
> mean, the need for more  algorithms.

zfcp is one of the drivers that don't have ramp-up/down mechanism in
place. And i am trying to understand what is required here.  Is there
currently work being done to get queue_depth ramp-up/down in the
midlayer?

>> If we moved code like that to the scsi layer, then is all the is needed 
>> is a interface to config this?

> Yep. As mentioned, figuring out what algorithm, for what device and
> configuration, will be the more interesting thing.

If the LLDs that currently have a private ramp-up/down mechanism in
place use a similar strategy, would it make sense to first move them
to common code that can be activated from a LLD? And later refine it
with device-specific behaviour?

--
Christof Schmitt
