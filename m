From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] ibmvscsi driver - sixth version
Date: Wed, 31 Mar 2004 19:10:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <406B5DFA.80201@pobox.com>
References: <opr3u0ffo7l6e53g@us.ibm.com> <20040225134518.A4238@infradead.org>  <opr3xta6gbl6e53g@us.ibm.com> <1079027038.2820.57.camel@mulgrave> <opr5qwiyw4l6e53g@us.ibm.com> <406B3FDA.9010507@pobox.com>  <opr5q1enb6l6e53g@us.ibm.com> <1080776399.11299.63.camel@mulgrave> <opr5q28vkql6e53g@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:6866 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262143AbUDAAKr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 19:10:47 -0500
In-Reply-To: <opr5q28vkql6e53g@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Dave Boutcher <sleddog@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

Dave Boutcher wrote:
> There will always be 1 (no more, no less) of these struct devices in the
> system, so I'll move the definition of this into iSeries_iommu and then
> just reference it from the driver.  I think that should abstract things
> sufficiently.


Sounds like a small module declaring devices such as this would be more 
appropriate than unrelated iommu code?

In a regular PCI system, the PCI bus probing code creates devices.  For 
platform-specific virtual devices, ppc64 needs "create my virtual 
devices" initialization code, it looks like.

	Jeff



