From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Fw: [Bugme-new] [Bug 7726] New: New LSI MegaRAID driver fails
	when ACPI is not present
Date: Thu, 21 Dec 2006 22:59:42 +0100
Message-ID: <1166738382.3365.1525.camel@laptopd505.fenrus.org>
References: <20061221125717.25f9b15c.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:39292 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423046AbWLUV7u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Dec 2006 16:59:50 -0500
In-Reply-To: <20061221125717.25f9b15c.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "Kolli, Neela Syam" <Neela.Kolli@engenio.com>, linux-scsi@vger.kernel.org

On Thu, 2006-12-21 at 12:57 -0800, Andrew Morton wrote:
> 
> Begin forwarded message:
> 
> Date: Thu, 21 Dec 2006 10:36:55 -0800
> From: bugme-daemon@bugzilla.kernel.org
> To: bugme-new@lists.osdl.org
> Subject: [Bugme-new] [Bug 7726] New: New LSI MegaRAID driver fails when ACPI is not present
> 
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=7726
> 
>            Summary: New LSI MegaRAID driver fails when ACPI is not present
>     Kernel Version: 2.6.17+
>             Status: NEW
>           Severity: normal
>              Owner: scsi_drivers-other@kernel-bugs.osdl.org
>          Submitter: bill@crowellsystems.com
> 
> 
> Most recent kernel where this bug did *NOT* occur:n/a
> Distribution:gentoo
> Hardware Environment:i686
> Software Environment:gcc 4.1.1, glibc 2.5
> Problem Description:
> during kernel boot, with noacpi option, megaraid driver detects and attempts to 
> start the controller. it fails and goes into an endless loop of error "waiting 
> for N commands to finish" and reset sequences.


this smells like a bios bug; the symptoms match horked irq routing; not
uncommon nowadays if you use the legacy, pre-acpi tables :(

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

