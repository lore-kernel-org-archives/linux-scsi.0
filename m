From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] remove a bogus check in sym2 driver
Date: 24 Jun 2003 12:22:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056453742.14612.27.camel@dhcp22.swansea.linux.org.uk>
References: <20030624033422.GB927@krispykreme>
	 <1056441769.14611.4.camel@dhcp22.swansea.linux.org.uk>
	 <20030624011723.0d13bbb1.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:24787
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S261939AbTFXLKS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 07:10:18 -0400
In-Reply-To: <20030624011723.0d13bbb1.akpm@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: anton@samba.org, linux-scsi@vger.kernel.org

On Maw, 2003-06-24 at 09:17, Andrew Morton wrote:
> Is this a bug in the adapter's BIOS or in the main BIOS?
> 
> If the latter then shouldn't this workaround live somewhere other than
> $RANDOM_DRIVER?

Who knows. The NCR/SYM stuff on some mainboards is deeply strange. As to
it being in a random driver - its not, its in the specific afflicted case.

That doesn't mean I disagree about the idea of filtering the problem in
the x86 pci code

