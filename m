From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Fix DAC960 driver on machines which don't support 64-bit
 DMA
Date: Fri, 31 Aug 2007 13:25:51 -0400
Message-ID: <46D84F1F.6090004@garzik.org>
References: <bug-8942-27@http.bugzilla.kernel.org/> <20070831151748.37C39108012@picon.linux-foundation.org> <20070831084259.fc2fd903.akpm@linux-foundation.org> <20070831161733.GC14130@parisc-linux.org> <20070831164746.GD14130@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965651AbXHaR03@vger.kernel.org>
In-Reply-To: <20070831164746.GD14130@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, Greg KH <greg@kroah.com>, alex@nibbles.it, dac@conglom-o.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> [Note: not tested.  I have a temporary shortage of machines with 5 volt
> PCI slots, and in any case, I think the DAC960 that I have is a V1 card]
> 
> Use PCI_DMA_* constants instead of own private definitions
> Fall back to 32-bit DMA mask if a 64-bit one fails
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>

ACK
