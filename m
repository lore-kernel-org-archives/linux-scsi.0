From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally attached
 PHYs)
Date: Fri, 21 Oct 2005 00:09:25 -0500
Message-ID: <43587805.7060306@cs.wisc.edu>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>	 <20051020160155.GA14296@lst.de> <4357CB03.4020400@adaptec.com>	 <20051020170330.GA16458@lst.de>  <4357F7DE.7050004@adaptec.com> <1129852879.30258.137.camel@bluto.andrew> <43583A53.2090904@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:8898 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964890AbVJUHKF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 03:10:05 -0400
In-Reply-To: <43583A53.2090904@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: andrew.patterson@hp.com, Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>

Jeff Garzik wrote:
> 
> Which is best?  I don't have a good answer.  Largely depends on the 
> situation, particularly queueing needs.  Networking and storage are 
> rapidly converging into "messaging", so the situation is highly fluid in 
> any case.  Coming from a networking background, I sorta lean towards the 
> solution noone has attempted yet:  netlink.

Dimitry and Alex did netlink for scsi_tranport_iscsi.c in scsi-misc. 
Which reminds me of some of the problems they discovered. See here
http://marc.theaimsgroup.com/?l=linux-netdev&m=111273099708516&w=2
