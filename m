From: Andrew Morton <akpm@digeo.com>
Subject: Re: [PATCH] remove a bogus check in sym2 driver
Date: Tue, 24 Jun 2003 01:17:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030624011723.0d13bbb1.akpm@digeo.com>
References: <20030624033422.GB927@krispykreme>
	<1056441769.14611.4.camel@dhcp22.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pao-ex01.pao.digeo.com ([12.47.58.20]:8928 "EHLO
	pao-ex01.pao.digeo.com") by vger.kernel.org with ESMTP
	id S264540AbTFXICc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 04:02:32 -0400
In-Reply-To: <1056441769.14611.4.camel@dhcp22.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: anton@samba.org, linux-scsi@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> > When we move to the scsi hotplug interface all this code will go away
>  > but in the short term we need the following fix.
> 
>  Hardly. When you move to scsi hotplug you'll still have to work around
>  the boxes where the same device pops up multiple times.
> 
>  Just check the domain is 0 ?
> 

Is this a bug in the adapter's BIOS or in the main BIOS?

If the latter then shouldn't this workaround live somewhere other than
$RANDOM_DRIVER?



