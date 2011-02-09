From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 2/2] cciss: Disable ASPM
Date: Wed, 9 Feb 2011 20:45:19 +0000
Message-ID: <20110209204519.GA20661@srcf.ucam.org>
References: <1297274831-10405-1-git-send-email-mjg@redhat.com> <1297274831-10405-2-git-send-email-mjg@redhat.com> <0F5B06BAB751E047AB5C87D1F77A77887D479C5C9C@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:46200 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab1BIUp3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 15:45:29 -0500
Content-Disposition: inline
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A77887D479C5C9C@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: ISS StorageDev <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Feb 09, 2011 at 08:35:02PM +0000, Miller, Mike (OS Dev) wrote:

> ASPM is supposed to be fixed on both Proliant and Smart Array by the 
> next generation of hardware. If that comes to fruition I suppose we 
> could make this patch conditional based on whether the underlying hw 
> really supports ASPM. Other than that this looks good.

Yes, ideally we'd make this conditional on the ID.

> Matthew, if Proliant BIOS tells the OS that ASPM is not supported does 
> the OS honor that and not attempt to use ASPM? I know there was a time 
> (maybe still is) when that bit in the ACPI table was not being set so 
> rhel6 tried to use ASPM and hence the BZ you mention. Sorry, but I 
> can't recall the proper terminology for the ACPI table related stuff.

We ended up identifying the heuristic that HP were using to disable ASPM 
on Windows and that's now implemented upstream, but if this hardware's 
available on cards then there's the possibility that someone might try 
it on a machine where ASPM isn't explicitly disabled.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
