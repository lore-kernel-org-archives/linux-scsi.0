From: James Smart <James.Smart@Emulex.Com>
Subject: Re: generating a Linux WWN?
Date: Thu, 27 Sep 2007 10:04:27 -0400
Message-ID: <46FBB86B.8000206@emulex.com>
References: <46FB8024.8040807@garzik.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60378 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbXI0OEf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 10:04:35 -0400
In-Reply-To: <46FB8024.8040807@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Uh, although this may work very well for small constrained configs, as one
who debugs larger environments (and things always grow or get connected in
ways you don't expect), depending on a random number for uniqueness makes
me very unsettled. Debugging that small-percentage potential, when/if it
does occur can be an absolute nightmare with all kinds of weird behavior.
Rarely will you solve it from the context of a single server. There are
lots of ways to cheat, but I believe they all have to be based on some
small part that is guaranteed to be unique (like the IEEE id's).

-- james s

Jeff Garzik wrote:
> Is there an accepted way to generate a SAS address, when the adapter 
> does not supply one (NVRAM invalid or missing, etc.)?
> 
> Unless somebody complains, I was just planning to use 
> get_random_bytes().  But maybe Linux has an IEEE id we can use, to make 
> the practice a bit more legitimate and avoid stomping on others?  Or an 
> IEEE id specifically designed for generated-address purposes?
> 
>     Jeff
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
