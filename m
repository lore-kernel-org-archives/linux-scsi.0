From: Christoph Hellwig <hch@lst.de>
Subject: Re: pulling failover out of qla2xxx
Date: Sat, 17 Jan 2004 17:52:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040117165226.GA29531@lst.de>
References: <B179AE41C1147041AA1121F44614F0B0598E34@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:8685 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266100AbUAQQw4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jan 2004 11:52:56 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598E34@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjanv@redhat.com>

On Fri, Jan 16, 2004 at 12:02:50PM -0800, Andrew Vasquez wrote:
> Now from a development and maintenance standpoint, I can understand
> the reluctance of having to accept a 100K file for each ISP type.
> But, let me just say QLogic is looking into other ways of distributing
> firmware images.  Finally, given the addition of some new binary-load
> user->kernel space facilities (namely request_firmware()) the space
> issue becomes moot.

If we go to request_firmware the frontend modules are mood and we should
just kill all of them.

