From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Thu, 21 Jun 2007 21:40:35 -0700
Message-ID: <20070622044035.GB5560@us.ibm.com>
References: <200706191025.30986.swen@vnet.ibm.com> <20070619171217.GA30099@infradead.org> <1182307586.10507.7.camel@mulgrave.il.steeleye.com> <20070621150308.GA29643@schmichrtp.de.ibm.com> <1182459492.3923.35.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:49043 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbXFVEke (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2007 00:40:34 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5M4eVXS025178
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jun 2007 00:40:31 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5M4eVr5239388
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2007 22:40:31 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5M4eVxP003085
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2007 22:40:31 -0600
Content-Disposition: inline
In-Reply-To: <1182459492.3923.35.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> A proposal to display the correct form of the LUN would be useful if you
> wish to make it? ...  The problem is really that SAM specifies a
> possible 4 level structure with 4 possible address methods per level.
> 
> The well known LUNs should be simple; there are only three: Report Lun,
> Access Controls and Target Log Pages.  The rest we really need input on.
> For instance, I could see the vendors wishing us to combine a
> multi-level flat addressing space into a single logical unit number,
> whereas I could see them wanting us to supply some sort of hierarchy for
> the peripheral and logical unit methods of addressing.
> 
> Since you're already using 2 level flat addressing, how do you want to
> see that represented?

James, why would we would not want to display the lun per SAM4 4.6.2 as
suggested by Stefan in a previous comment.

-andmike
--
Michael Anderson
andmike@us.ibm.com
