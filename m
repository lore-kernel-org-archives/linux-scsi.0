From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: how to use scsi_remove_device
Date: Sun, 19 Mar 2006 20:37:17 +0100
Message-ID: <441DB2ED.703@s5r6.in-berlin.de>
References: <1142598225.25906.256865850@webmail.messagingengine.com>	 <441B1388.20704@s5r6.in-berlin.de>  <441B1C7F.2090605@s5r6.in-berlin.de> <1142629908.15834.15.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:50589 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750755AbWCSTiA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Mar 2006 14:38:00 -0500
In-Reply-To: <1142629908.15834.15.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi@vger.kernel.org, Eric Moore <Eric.Moore@lsil.com>, Leon Woestenberg <leonw@mailcan.com>

Mark Haverkamp wrote:
> On Fri, 2006-03-17 at 21:30 +0100, Stefan Richter wrote:
>>But aacraid and mptsas call scsi_add_device + scsi_remove_device + 
>>scsi_device_put. AFAICS this is either one scsi_device_put too many or 
>>one scsi_device_get too few.
...
> Looking at commsup.c, though, I think that the scsi_device_put is done
> after the scsi_device_lookup
...

Yes, the scsi_device_put is correct since scsi_device_lookup took a 
reference.
-- 
Stefan Richter
-=====-=-==- --== =--==
http://arcgraph.de/sr/
