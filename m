From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 0/14] qla2xxx: updates for 2.6.24 [8.02.00-k7].
Date: Thu, 17 Jan 2008 09:53:37 -0800
Message-ID: <20080117175337.GC20186@plap3.qlogic.org>
References: <20080117165940.GA19033@plap3.qlogic.org> <20080117173305.GB19033@plap3.qlogic.org> <1200591844.3255.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:32605 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbYAQRxq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 12:53:46 -0500
Content-Disposition: inline
In-Reply-To: <1200591844.3255.26.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

On Thu, 17 Jan 2008, James Bottomley wrote:

> On Thu, 2008-01-17 at 09:33 -0800, Andrew Vasquez wrote:
> > On Thu, 17 Jan 2008, Andrew Vasquez wrote:
> > 
> > > This patchset updates the qla2xxx driver to 8.02.00-k7.
> > ...
> > 
> > 
> > BTW:  Small typo in the subject, it's obvious these patches aren't for
> > 2.6.24, instead, meant for the next merge window of 2.6.25...
> 
> I was just about to ask about that.
> 
> Your patches are all unnumbered, which makes applying them a pain unless
> they're all independent; are they?

Cazzo!  No, sorry about that, there's some ordering required.  The
order should be:

[PATCH 01/14] qla2xxx: Consolidate duplicate sense-data handling codes.
[PATCH 02/14] qla2xxx: Retrieve additional HBA port statistics from recent ISPs.
[PATCH 03/14] qla2xxx: Fix for 32-bit platforms with 64-bit resources.
[PATCH 04/14] qla2xxx: Wait for FLASH write-protection to complete after a write.
[PATCH 05/14] qla2xxx: Restrict MSI/MSI-X enablement on select ISP2432-type HBAs.
[PATCH 06/14] qla2xxx: Don't schedule the DPC routine to perform an issue-lip request.
[PATCH 07/14] qla2xxx: Use completion routines.
[PATCH 08/14] qla2xxx: Add a filter to compare port_name against the physical on vport creation.
[PATCH 09/14] qla2xxx: Code cleanups.
[PATCH 10/14] qla2xxx: Trace-Control naming cleanups.
[PATCH 11/14] qla2xxx: Add Fibre Channel Event (FCE) tracing support.
[PATCH 12/14] qla2xxx: Correct late-memset() of EFT buffer.
[PATCH 13/14] qla2xxx: Issue correct MBC_INITIALIZE_FIRMWARE command.
[PATCH 14/14] qla2xxx: Update version number to 8.02.00-k7.

I believe git-send-email adjusts the 'seconds' field in the 'Date'
header, so hopefully, your threaded email reader maintained the order.
If not, if you like, I can resend with the X/Y prefix.
