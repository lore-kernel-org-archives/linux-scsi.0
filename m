From: Christoph Hellwig <hch@lst.de>
Subject: Re: pulling failover out of qla2xxx
Date: Sat, 17 Jan 2004 17:53:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040117165350.GB29531@lst.de>
References: <B179AE41C1147041AA1121F44614F0B0598E34@AVEXCH02.qlogic.org> <40084860.90902@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:10733 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266106AbUAQQyF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jan 2004 11:54:05 -0500
Content-Disposition: inline
In-Reply-To: <40084860.90902@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjanv@redhat.com>

On Fri, Jan 16, 2004 at 03:24:00PM -0500, Jeff Garzik wrote:
> is).  Heck, if there is HBA-chip-specific code in qla2xxx, move that out 
> to the specific driver's module too.

Well, there is quite a bit of code for just one HBA type, but it's
always a few lines of code in large common codepathes (and a slightly
different register layout).  We though about this but it's not easily
feasible.

