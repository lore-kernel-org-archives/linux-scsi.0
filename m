From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 18:37:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409211837.46923.jbarnes@engr.sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0DD04E5@AVEXCH02.qlogic.org> <20040921214434.GH146363@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:28548 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S267263AbUIUWiF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 18:38:05 -0400
In-Reply-To: <20040921214434.GH146363@sgi.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@steeleye.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 5:44 pm, Jeremy Higdon wrote:
> > Just during initialization (qla2x00_chip_diag() and qla2x00_setup_chip())
> > and after a firmware dump (qla_dbg.c -- which requires a full
> > re-initialization to recover).  If the driver is in the process of
> > performing a firmware-dump, the RISC has already been paused and nothing
> > is executing within the firmware.
>
> Well then 10us should be plenty of time.  Maybe 20 just to be extra sure.

Don't forget the case of a driver that's insmod'd into a running, busy system.

Jesse
