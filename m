From: KY Srinivasan <kys@microsoft.com>
Subject: RE: hyperv storvsc cleanup / optimization
Date: Sun, 19 Oct 2014 15:20:53 +0000
Message-ID: <d0038ee4d59e4576bab2eff0d0771cc6@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1413731895-6967-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0139.outbound.protection.outlook.com ([157.56.111.139]:51406
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751109AbaJSPfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Oct 2014 11:35:54 -0400
In-Reply-To: <1413731895-6967-1-git-send-email-hch@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Sunday, October 19, 2014 8:18 AM
> To: KY Srinivasan
> Cc: linux-scsi@vger.kernel.org
> Subject: hyperv storvsc cleanup / optimization
> 
> Hi KY,
> 
> can you throw the patch below into your testing rig?  It converts the storvsc
> driver to use our new cmd_size field, and thus avoids all the slab/mepool
> infrastructure for private data in the driver.

Will do.

K. Y

