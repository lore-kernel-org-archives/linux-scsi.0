From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Fw: Re: 2.6.10-rc2-mm3
Date: Wed, 24 Nov 2004 17:08:27 -0800
Message-ID: <200411241708.27187.david-b@pacbell.net>
References: <20041122162206.0d43cd30.akpm@osdl.org> <200411231816.38235.david-b@pacbell.net> <200411242201.13815.cova@ferrara.linux.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ylpvm15-ext.prodigy.net ([207.115.57.46]:36030 "EHLO
	ylpvm15.prodigy.net") by vger.kernel.org with ESMTP id S262884AbUKYB0X
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Nov 2004 20:26:23 -0500
In-Reply-To: <200411242201.13815.cova@ferrara.linux.it>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb-devel@lists.sourceforge.net
Cc: Fabio Coatti <cova@ferrara.linux.it>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

On Wednesday 24 November 2004 13:01, Fabio Coatti wrote:
> 
> Ok, it seems that now the device is detected without problems at first try; 
> I've tried several times with this setup in modprobe.conf:
> options usbcore old_scheme_first=1
> and I'm unable to reproduce the behaviour of missed detection of usb device, 
> no matter how many times I can try, so I think you have hit the point, many 
> thanks :)

Interesting.  We expected some devices would be unhappy
with that new scheme, but this is the first time I remember
hearing about an unhappy one.  Well, 2.6.10 is young ... :)

- Dave

 
> As expected, the faulty behaviour of kobject is still here (double 
> registration..), but now the device is working on first try, so half the 
> problem is gone away :)
> I get some scsi errors about unit not ready, but the driver seems to handle 
> this quite well.
> 
