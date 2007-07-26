From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v2] Remove libsas PCI dependencies
Date: Thu, 26 Jul 2007 13:46:56 -0400
Message-ID: <46A8DE10.8030108@garzik.org>
References: <Pine.SOC.4.64.0707261129220.17385@math.ut.ee>  <46A867AB.7050007@garzik.org> <1185454007.3501.34.camel@localhost.localdomain> <46A8A185.7010609@garzik.org> <Pine.SOC.4.64.0707262030090.1921@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:49711 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758602AbXGZRq7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 13:46:59 -0400
In-Reply-To: <Pine.SOC.4.64.0707262030090.1921@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>

Meelis Roos wrote:
>> Eliminate unnecessary PCI dependencies in libsas.  It should use generic DMA
>> and struct device like other subsystems.
> 
> Compiles fine, unfortunately I can not test kernels on this machine 
> since I have yet to dig out the reason my kernels do not boot.

That's about the best we can ask for :)  Thanks.  I'm pretty sure you do 
not have any SAS hardware in your sparc32...

	Jeff



