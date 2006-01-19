From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 5735] New: System boot hangs Adaptec 2100S
 card
Date: Thu, 19 Jan 2006 13:51:16 -0800
Message-ID: <20060119135116.07c57a79.akpm@osdl.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F020CC9AC@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:7556 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1161286AbWASVwp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2006 16:52:45 -0500
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F020CC9AC@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

"Salyzyn, Mark" <mark_salyzyn@adaptec.com> wrote:
>
> This is probably fixed by the patch associated with
> 
> 	[PATCH 2.6.15] I2O: move pci_request_regions() just behind
> pci_enable_device()
> 

OK. thanks.  Felix, can you please test 2.6.16-rc1 and update bugzilla
appropriately?

Mark, you chopped bugme-daemon off the Cc: list.  Please retain it, so this
stuff gets filed into bugzilla, thanks.

