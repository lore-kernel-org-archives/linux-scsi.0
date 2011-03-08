From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH] sd: sd should not modify read capacity, cache type or
 write protect flag on rescan when there is a transport error
Date: Tue, 08 Mar 2011 08:22:31 -0600
Message-ID: <1299594151.2476.10.camel@mulgrave.site>
References: <D8C50530D6022F40A817A35C40CC06A706576F76F2@DUBX7MCDUB01.EMEA.DELL.COM>
	 <1298907291.2487.18.camel@mulgrave.site>
	 <D8C50530D6022F40A817A35C40CC06A706577BC8AE@DUBX7MCDUB01.EMEA.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab1CHOWg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Mar 2011 09:22:36 -0500
In-Reply-To: <D8C50530D6022F40A817A35C40CC06A706577BC8AE@DUBX7MCDUB01.EMEA.DELL.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Menny_Hamburger@Dell.com
Cc: linux-scsi@vger.kernel.org

Could you not top post: it makes it hard to follow what you're actually
replying to.

On Tue, 2011-03-08 at 09:30 +0000, Menny_Hamburger@Dell.com wrote:
> I think the kernel should have some ability to handle this situation
> (or at least propagate the fact that there is a problem) without the
> userland being involved.
> 
> We could add this as a devinfo option - enable this functionality for
> specific devices.
> Another totally different way may be to have the SCSI layer send some
> notification (unknown property, needs rescan) that could be picked up
> and handled by the transport layer.  

This is the hotplug I suggested, isn't it?

James


