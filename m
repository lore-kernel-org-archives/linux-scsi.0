From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: One question about SCSI device hotplug
Date: Tue, 1 Mar 2005 22:57:52 -0600
Message-ID: <20050302045752.GC20042@lists.us.dell.com>
References: <8126E4F969BA254AB43EA03C59F44E8401850062@pdsmsx404>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from lists.us.dell.com ([143.166.224.162]:11614 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S262174AbVCBE6O
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 23:58:14 -0500
Content-Disposition: inline
In-Reply-To: <8126E4F969BA254AB43EA03C59F44E8401850062@pdsmsx404>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Zhao, Forrest" <forrest.zhao@intel.com>
Cc: James.Smart@Emulex.Com, matthew@wil.cx, linux-scsi@vger.kernel.org, "Caushik, Ramesh" <ramesh.caushik@intel.com>, sdake@mvista.com

On Wed, Mar 02, 2005 at 12:47:46PM +0800, Zhao, Forrest wrote:
> < but the LLDD doesn't get an interrupt from the firmware on such
> events).
> 
> So you mean that when SCSI device is surprise-removed, HBA will not
> assert an interrupt to kernel? Even LLDD doesn't know the SCSI device is
> removed?

Exactly.  Some controllers know, and assert events up to their LLDD.
Jame's Emulex driver apparently does, perhaps this holds true for all
FC devices.

Some firmwares (LSI megaraid for sure, Adaptec SCSI I believe) don't.

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
