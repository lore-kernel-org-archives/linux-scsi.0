From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Panic from mptspi_dv_renegotiate_work in 2.6.18-mm2
Date: Mon, 02 Oct 2006 20:51:15 -0400
Message-ID: <4521B403.2050606@garzik.org>
References: <664A4EBB07F29743873A87CF62C26D703507DA@NAMAIL4.ad.lsil.com>	<20061002163733.610a3c1f.akpm@osdl.org>	<4521AF8D.4050209@garzik.org> <20061002174147.82093f20.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:35019 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S965550AbWJCAvV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 20:51:21 -0400
In-Reply-To: <20061002174147.82093f20.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>, Martin Bligh <mbligh@google.com>, LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> On Mon, 02 Oct 2006 20:32:13 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> FWIW, I am seeing precisely this problem, in the latest -git.
> 
> I just sent this to Linus.  Fingers crossed, it'll fix...
> 
> From: Andrew Morton <akpm@osdl.org>
> 
> 54dbc0c9ebefb38840c6b07fa6eabaeb96c921f5 is causing various people's machines
> to fail to map PCI resources.
> 
> Revert it in preparation for addressing the show-APICs-in-/proc/iomem
> requirement in a different manner.
> 
> Cc: Aaron Durbin <adurbin@google.com>
> Cc: Andi Kleen <ak@muc.de>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>

I'll give it a good test.  My sata_mv (requires PCI domains) also died 
with a bunch of timeouts.  Lack of interrupts, or lack of PCI resources, 
is definitely indicative of a cause.

	Jeff



