From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: MPT Fusion initialization in 2.6.23.12
Date: Mon, 14 Jan 2008 09:45:11 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70C5CEFF@NAMAIL4.ad.lsil.com>
References: <20080111140120.GA2116@synapse.neuralscape.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56833 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbYANQpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 11:45:21 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20080111140120.GA2116@synapse.neuralscape.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Shaeffer <shaeffer@neuralscape.com>, linux-scsi@vger.kernel.org

On Friday, January 11, 2008 7:01 AM, Karen Shaeffer wrote: 

> mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: 
> type=08h, page=00h, action=01h, form=0000000Fh
> 
> I've traced through the mptbase.c code and can see these
> invalid config pages are read from the controller during
> initialization. This doesn't appear to cause any ill
> effects, but I am wondering how to resolve this? Maybe
> a MPT BIOS or MPT firmware upgrade will fix this?
> 

Karen - this is not an error.  The driver present the sas topology to
the transport layer. It does so by scaning firmware config pages by
passing XXX_FORM_GET_NEXT_HANDLE.  When there are no more devices, the
firmware returns "Invalid Page".  This applies for expanders as well.
I actually thought his particular print was only displayed by toggling
debug logging, meaning by default settings, this would not apear.

Eric
