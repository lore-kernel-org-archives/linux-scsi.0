From: Alan Cox <alan@redhat.com>
Subject: Re: [ANNOUNCE]: version 2.00.3 megaraid driver for 2.4.x and 2.5.67 kernels
Date: Thu, 17 Apr 2003 09:23:34 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200304171323.h3HDNYm17322@devserv.devel.redhat.com>
References: <20030417135719.A13189@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.200]:52667 "EHLO
	devserv.devel.redhat.com") by vger.kernel.org with ESMTP
	id S261334AbTDQNOJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Apr 2003 09:14:09 -0400
In-Reply-To: <20030417135719.A13189@infradead.org> from "Christoph Hellwig" at Ebr 17, 2003 01:57:19 
List-Id: linux-scsi@vger.kernel.org
Cc: Alan Cox <alan@redhat.com>, Christoph Hellwig <hch@infradead.org>, Mukker Atul <atulm@lsil.com>, "'James.Bottomley@steeleye.com'" <James.Bottomley@steeleye.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-megaraid-devel@dell.com'" <linux-megaraid-devel@dell.com>, "'linux-megaraid-announce@dell.com'" <linux-megaraid-announce@dell.com>

> On Thu, Apr 17, 2003 at 08:52:16AM -0400, Alan Cox wrote:
> > >     Do you really need this?  Why can you use
> > >     struct device_driver->shutdown?
> > 
> > Not on 2.2
> 
> This is a 2.5-only driver (in fact a 2.5 only patch against a 2.4 driver)

2.0 exists for 2.4 as well. I dont know about for 2.2

