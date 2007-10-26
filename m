From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: What layer are "transport classes" in?
Date: Fri, 26 Oct 2007 16:43:52 +0200
Message-ID: <4721FD28.6090705@s5r6.in-berlin.de>
References: <200710251713.56136.rob@landley.net> <1193350500.3301.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:55183 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbXJZOny (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2007 10:43:54 -0400
In-Reply-To: <1193350500.3301.39.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Rob Landley <rob@landley.net>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2007-10-25 at 17:13 -0500, Rob Landley wrote:
>> Looking at the scsi_transport_*.c files...  Are these part of the lower layer 
>> or the midlayer?  I _think_ these exist primarily to expose information about 
>> the lower layers through sysfs, but I'm very fuzzy on this...
> 
> They're part of the mid layer (the lower layer is simply all the
> drivers).
  ^^^^^^^
>> Should they be documented as part of the lower layer or the midlayer or are 
>> they their own area...?
> 
> They should be documented on their own.  They're basically service
> libraries and sysfs export helpers for drivers.
                                         ^^^^^^^
(Rob, in case it's not already clear from context, James is referring
with "drivers" only to low-level drivers here, not to the high-level
drivers sd, sg, sr, st, osst, ch.)
-- 
Stefan Richter
-=====-=-=== =-=- ==-=-
http://arcgraph.de/sr/
