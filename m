From: Tore Anderson <tore@linpro.no>
Subject: Re: Recurring qla2xxx crashes (maybe APIC related)
Date: Mon, 28 Apr 2008 08:37:16 +0200
Message-ID: <4815709C.3060502@linpro.no>
References: <4811ACAC.7060808@linpro.no> <20080425155018.GG8849@plap4> <48120F8B.7060005@linpro.no> <20080425171821.GK8849@plap4>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.linpro.no ([213.236.139.167]:59796 "EHLO
	mailhub.linpro.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbYD1GhS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2008 02:37:18 -0400
In-Reply-To: <20080425171821.GK8849@plap4>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi again,

* Andrew Vasquez

> Hmm, MSI is enabled:

Indeed - seems to be the default behaviour.

> could you try disabling MSI via 'pci=nomsi' (I believe), we've dealt 
> with a large number of problem reports where customers reported 'odd'
> behaviours (no interrupt routining) with several motherboard
> chipsets. At least it could be another useful datapoint...

The system has now been up for 58 hours straight with MSI disabled per
your suggestion.  This is almost a new record, usually it has crashed
once per day or more.  I won't open the champagne before a week more has
passed, but this looks _very_ promising!

Thank you very much for your help in tracking this down!  Be sure to let
me know if you want any more information and I'll see what I can do.
The system isn't yet back in full production, so I have a small window
of opportunity to reproduce the problem, test patches, and so on.

Regards,
-- 
Tore Anderson
