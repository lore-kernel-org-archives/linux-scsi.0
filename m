From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What layer are "transport classes" in?
Date: Thu, 25 Oct 2007 17:15:00 -0500
Message-ID: <1193350500.3301.39.camel@localhost.localdomain>
References: <200710251713.56136.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39561 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753539AbXJYWPO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Oct 2007 18:15:14 -0400
In-Reply-To: <200710251713.56136.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: linux-scsi@vger.kernel.org

On Thu, 2007-10-25 at 17:13 -0500, Rob Landley wrote:
> Looking at the scsi_transport_*.c files...  Are these part of the lower layer 
> or the midlayer?  I _think_ these exist primarily to expose information about 
> the lower layers through sysfs, but I'm very fuzzy on this...

They're part of the mid layer (the lower layer is simply all the
drivers).

> Should they be documented as part of the lower layer or the midlayer or are 
> they their own area...?

They should be documented on their own.  They're basically service
libraries and sysfs export helpers for drivers.

James


