From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Sat, 15 Mar 2008 21:38:27 +0100
Message-ID: <47DC33C3.8060205@s5r6.in-berlin.de>
References: <20080313210655.GA13468@kroah.com>	 <1205514958.2904.27.camel@localhost.localdomain>	 <1205529619.2904.87.camel@localhost.localdomain>	 <1205531922.3522.57.camel@lov.site>	 <1205590788.6767.12.camel@localhost.localdomain>	 <1205594256.3109.53.camel@lov.site>	 <1205597776.6767.40.camel@localhost.localdomain>	 <1205604100.6767.43.camel@localhost.localdomain>	 <1205605604.3109.148.camel@lov.site> <1205606060.6767.55.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:43324 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbYCOUio (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Mar 2008 16:38:44 -0400
In-Reply-To: <1205606060.6767.55.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

James Bottomley wrote:
> If the backlink were called "enclosure_component", that would probably
> be fine.  Not sure I have a better name than "device" for the actual
> device in the enclosure slot, though.

enclosed_device

or enclosed/<bus_id> if it is a 1:n relationship
-- 
Stefan Richter
-=====-==--- --== -====
http://arcgraph.de/sr/
