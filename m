From: "Nguyen, Tom L" <tom.l.nguyen@intel.com>
Subject: RE: MSI in 2.6.9-rc2-mm1 kernel
Date: Mon, 20 Sep 2004 12:05:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <C7AB9DA4D0B1F344BF2489FA165E502406610519@orsmsx404.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr12.intel.com ([134.134.136.15]:57249 "EHLO
	orsfmr001.jf.intel.com") by vger.kernel.org with ESMTP
	id S267250AbUITTFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Sep 2004 15:05:34 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: mikem@beardog.cca.cpqcorp.net, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, "Nguyen, Tom L" <tom.l.nguyen@intel.com>

On Friday, September 17, 2004 3:23 PM, Mike Miller wrote:
 
>Has anyone tried an MSI capable device in 2.6.9-rc2-mm1? When
intializing my
>MSI capable controller I get a return value of zero from pci_enable_msi
but
>the system hangs at that point as if I'm not getting the MSI vector.
>
>Just started looking at this, but I was wondering if anyone else has
seen this?

MSI support in 2.6.9-rc2-mm1 kernel works fine for me. It seems that you
should check whether MSI is supported by the platform and processors of
your system. Also, contact the vendor of your MSI device to see whether
a device has any MSI issues, which you are not aware of.

Thanks,
Long  
