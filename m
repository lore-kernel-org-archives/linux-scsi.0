From: "J.Flash" <jf@ad2u.ath.cx>
Subject: Re: sym2 version 2.2.1
Date: Wed, 25 May 2005 20:44:11 +0100
Message-ID: <4294D58B.4000205@ad2u.ath.cx>
References: <20050520191543.GG6857@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpc1-rdng8-4-0-cust146.winn.cable.ntl.com ([81.110.67.146]:16873
	"EHLO ikarus.ad2u.ath.cx") by vger.kernel.org with ESMTP
	id S261541AbVEYTo2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 15:44:28 -0400
In-Reply-To: <20050520191543.GG6857@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

Hi,
I would like to know if this issue has been fixed:
https://bugzilla.redhat.com/bugzilla/long_list.cgi?buglist=139949
I am experiencing all that on the latest stable vanilla kernel, ever
since 2.6.9, on my SMP system that has this controller onboard.
Thank you,
J.F.

Matthew Wilcox wrote:

>sym2 version 2.2.1:
> - Fix MMIO BAR detection (Thanks to Bob Picco)
> - Fix odd-sized transfers with a wide bus (Thanks to Larry Stephens)
> - Write posting fixes (Thanks to Thibaut Varene)
> - Change one of the GFP_KERNEL allocations back into a GFP_ATOMIC
> - Make CCB_BA() return a script-endian address
> - Move range checks and disabling of devices from the queuecommand path
>   to slave_alloc() 
> - Remove a warning in sym_setup_cdb()
> - Keep a pointer to the scsi_target instead of the scsi_dev in the tcb
> - Remove a check for the upper layers passing an oversized cmd
> - Replace CAM_REQ_ constants with the Linux DID_ constants
> - Replace CAM_DIR_ constants with the Linux DMA_ constants
> - Inline sym_read_parisc_pdc() on non-parisc systems
>
>  
>

