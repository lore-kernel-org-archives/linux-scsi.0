From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] remove a bogus check in sym2 driver
Date: 24 Jun 2003 09:02:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056441769.14611.4.camel@dhcp22.swansea.linux.org.uk>
References: <20030624033422.GB927@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:58834
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S263921AbTFXHuq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 03:50:46 -0400
In-Reply-To: <20030624033422.GB927@krispykreme>
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: linux-scsi@vger.kernel.org, akpm@digeo.com

On Maw, 2003-06-24 at 04:34, Anton Blanchard wrote:
> Hi,
> 
> The sym2 driver has a check for a very broken bios where it seems 
> devices appear twice. This test is broken on a machine with PCI domains
> since busnumber:devfn is not a unique identifier.
> 
> When we move to the scsi hotplug interface all this code will go away
> but in the short term we need the following fix.

Hardly. When you move to scsi hotplug you'll still have to work around
the boxes where the same device pops up multiple times.

Just check the domain is 0 ?

