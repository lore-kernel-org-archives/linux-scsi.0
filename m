From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] libsas: Check that the firmware loader is present in
	sas_request_addr
Date: Thu, 06 Mar 2008 16:16:21 -0600
Message-ID: <1204841781.3062.69.camel@localhost.localdomain>
References: <20080306090904.258f92eb.randy.dunlap@oracle.com>
	 <20080306181645.GA6046@kroah.com> <47D03666.9080000@oracle.com>
	 <20080306210212.GC7430@tree.beaverton.ibm.com>
	 <1204838233.3062.53.camel@localhost.localdomain>
	 <20080306140437.8a193423.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36969 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753791AbYCFWQZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 17:16:25 -0500
In-Reply-To: <20080306140437.8a193423.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Greg KH <greg@kroah.com>, linux-next@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>

On Thu, 2008-03-06 at 14:04 -0800, Randy Dunlap wrote:
> On Thu, 06 Mar 2008 15:17:13 -0600 James Bottomley wrote:
> 
> > We could do it that way ... I suspect what Greg was asking for was more
> > like this:
> > 
> > James
> 
> Builds cleanly for CONFIG_FW_LOADER=n.
> I'm having trouble setting CONFIG_FW_LOADER=m for test building it.

Ironically, I can, and have, tested that config ... I just couldn't
build with CONFIG_FW_LOADER=n.

I think we've covered all the test cases between us.

> Anyway,
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

James


