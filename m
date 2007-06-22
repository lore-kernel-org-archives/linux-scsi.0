From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Fri, 22 Jun 2007 09:11:39 -0500
Message-ID: <1182521500.3923.49.camel@mulgrave.il.steeleye.com>
References: <200706191025.30986.swen@vnet.ibm.com>
	 <20070619171217.GA30099@infradead.org>
	 <1182307586.10507.7.camel@mulgrave.il.steeleye.com>
	 <20070621150308.GA29643@schmichrtp.de.ibm.com>
	 <1182459492.3923.35.camel@mulgrave.il.steeleye.com>
	 <20070622044035.GB5560@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60179 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754717AbXFVOLm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2007 10:11:42 -0400
In-Reply-To: <20070622044035.GB5560@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

On Thu, 2007-06-21 at 21:40 -0700, Mike Anderson wrote:
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > A proposal to display the correct form of the LUN would be useful if you
> > wish to make it? ...  The problem is really that SAM specifies a
> > possible 4 level structure with 4 possible address methods per level.
> > 
> > The well known LUNs should be simple; there are only three: Report Lun,
> > Access Controls and Target Log Pages.  The rest we really need input on.
> > For instance, I could see the vendors wishing us to combine a
> > multi-level flat addressing space into a single logical unit number,
> > whereas I could see them wanting us to supply some sort of hierarchy for
> > the peripheral and logical unit methods of addressing.
> > 
> > Since you're already using 2 level flat addressing, how do you want to
> > see that represented?
> 
> James, why would we would not want to display the lun per SAM4 4.6.2 as
> suggested by Stefan in a previous comment.

Because in a two LUN system, what was LUN 1 would then become LUN
0x1000000000000 which looks a bit unpalatable.

James


