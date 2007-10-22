From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: LSIFC909 problem
Date: Mon, 22 Oct 2007 10:33:41 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70A87BF1@NAMAIL4.ad.lsil.com>
References: <20071022161804.GB27248@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:37896 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbXJVQds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Oct 2007 12:33:48 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20071022161804.GB27248@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: egi <pfammatter-egi@swissonline.ch>, linux-scsi@vger.kernel.org, mdr@sgi.com, "Shirron, Stephen" <Stephen.Shirron@lsi.com>

On Monday, October 22, 2007 10:18 AM,  Matthew Wilcox wrote:
> Sounds like we need a new driver written to support the FC909 then.
> Unless we could pretend the FC909 is a parallel scsi card or something
> ... that wasn't quite clear from Michael's mail.
> 

ok, are you suggesting for FC909 we call scsi_scan_host, else chips we
"hook into transport layer"?

The way I understood from Stephen Shirron, is the FC909 is using mpi
version 1.0, and all the other FC cards are on mpi version 1.2 or 1.5.
The mpi defines the interface between driver and firmware.   The older
mpi version 1.0 is missing feature needed for the FC transport to work.


Eric
