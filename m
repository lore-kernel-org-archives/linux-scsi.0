From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 2/2] fusion - honour return value of pci_enable_device() in mpt_resume()
Date: Fri, 16 Mar 2007 18:00:57 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70650CF9@NAMAIL4.ad.lsil.com>
References: <20070316070550.GC1081@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:41403 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992475AbXCQABH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Mar 2007 20:01:07 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070316070550.GC1081@verge.net.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Horms <horms@verge.net.au>, linux-scsi@vger.kernel.org

On Friday, March 16, 2007 1:06 AM,  Horms wrote:

> Honour the return value of pci_enable_device(), which
> seems to be a desirable thing to do:

Both patch's look good.

Thanks,
Eric
