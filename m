From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: bug 2400
Date: 01 Apr 2004 17:40:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080859235.2117.61.camel@mulgrave>
References: <20040401131502.41136788.akpm@osdl.org>
	<1080856352.5300.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:31977 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263105AbUDAWks (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 17:40:48 -0500
In-Reply-To: <1080856352.5300.43.camel@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: gulickconsulting@direcway.com
Cc: Andrew Morton <akpm@osdl.org>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-04-01 at 16:52, Matt Gulick wrote:
> Where you will get into trouble is that SCSI is not considered to be a
> 'Dynamic' bus.  Devices do not normally come and go, while USB and 1394
> devices are 'Hot Plugable'.

It isn't? considering all the refcounting work that's gone into the SCSI
stack to make it support hotplug transports, I don't think such a
blanket statement is supportable.

James


