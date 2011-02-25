From: Robert Love <robert.w.love@intel.com>
Subject: Re: [PATCH] libfc: introduce __fc_fill_fc_hdr that accepts fc_hdr
 as an argument
Date: Fri, 25 Feb 2011 15:05:32 -0800
Message-ID: <1298675132.4935.1.camel@fritz>
References: <1296787638.268.788.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
	 <1298652784.2459.37.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27393 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932869Ab1BYXFd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 18:05:33 -0500
In-Reply-To: <1298652784.2459.37.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Bhanu Gollapudi <bprakash@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Mike Christie <michaelc@cs.wisc.edu>

On Fri, 2011-02-25 at 08:53 -0800, James Bottomley wrote:
> On Thu, 2011-02-03 at 18:47 -0800, Bhanu Gollapudi wrote:
> > fc_fill_fc_hdr() expects fc_frame as an argument. Introduce __fc_fill_fc_hdr to
> > accept fc_frame_header as an argument.
> 
> Not sure you noticed this, Robert, but I need it to get the bnx2fc
> driver compiling ... could you ack or send as part of the libfc updates?
> 

It's in the update I just mailed, [patch 4/8].

Thanks, //Rob

