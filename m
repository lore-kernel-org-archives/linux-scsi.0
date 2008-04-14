From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: mptsas problem
Date: Mon, 14 Apr 2008 12:16:11 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229FBE34D@NAMAIL2.ad.lsil.com>
References: <20080413204910.GA19651@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:40553 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765920AbYDNSRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Apr 2008 14:17:15 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080413204910.GA19651@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Richard Scobie <richard@sauce.co.nz>, linux-scsi@vger.kernel.org

On Sunday, April 13, 2008 2:49 PM, Wakko Warner wrote:

> > depth of 64 it may be queueing internally as well.  You could try
> > lowering the lsi queue to 31 and seeing if it makes a difference.
> 
> IIRC, someone said the LSIs does queue in firmware.
> 

It was probably me that told you that.   Anyways,  the lsiutil 100
output you sent me last week indicated youre controller has NCQ
disabled.     You need new firmware and controller chip rev in order to
support NCQ.  You should contact LSI support to obtain which versions of
firmware and chip rev that is required.   Meanwhile your controller will
queuing commands for SATA, only sending one command across the wire at a
time.   For SAS, you will not have this issue.

Eric
