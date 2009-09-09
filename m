From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA - V4.
Date: Wed, 09 Sep 2009 16:54:08 -0700
Message-ID: <4AA84020.6040504@goop.org>
References: <1252458903.24914.73.camel@ank32.eng.vmware.com>	<4AA8177A.2020606@codemonkey.ws>	<1252533093.24633.40.camel@ank32.eng.vmware.com>	<4AA8284A.3010908@codemonkey.ws>	<20090909230854.GA4495@infradead.org> <4AA83B88.2020104@codemonkey.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from claw.goop.org ([74.207.240.146]:39972 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbZIIXyG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Sep 2009 19:54:06 -0400
In-Reply-To: <4AA83B88.2020104@codemonkey.ws>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, LKML <linux-kernel@vger.kernel.org>, virtualization <virtualization@lists.linux-foundation.org>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>, James Bottomley <James.Bottomley@suse.de>, akataria@vmware.com, Rolf Eike Beer <eike-kernel@sf-tec.de>

On 09/09/09 16:34, Anthony Liguori wrote:
> We haven't even been successful in getting the Xen folks to present 
> their work on lkml before shipping it to their users.  Why would we 
> expect more from VMware if we're willing to merge the Xen stuff?
>   

The Xen code may be out of tree, but it has always been readily
available from a well-known place.  I don't think its comparable.

    J
