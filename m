From: Christoph Hellwig <hch@lst.de>
Subject: Re: pulling failover out of qla2xxx
Date: Sat, 17 Jan 2004 19:51:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040117185119.GA30850@lst.de>
References: <B179AE41C1147041AA1121F44614F0B0598E34@AVEXCH02.qlogic.org> <20040117165226.GA29531@lst.de> <20040117184737.GA21846@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:34944 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265719AbUAQSve (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jan 2004 13:51:34 -0500
Content-Disposition: inline
In-Reply-To: <20040117184737.GA21846@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI <linux-scsi@vger.kernel.org>

On Sat, Jan 17, 2004 at 07:47:37PM +0100, Arjan van de Ven wrote:
> the "problem" for now is booting from qlogic; initrd's in current distros
> don't work with request_firmware yet... while I'm sure this is a temporary
> inconvenience, it is a real one. And it's not like the frontend modules are
> THAT huge to keep around for a while until enough distros have this working
> well.

Well, we'll have to keep them around until everything works of course.
As one module per firmware as currently in mainline.

