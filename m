From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Mount by WWN (FC, using qlogic 2200)
Date: 04 Feb 2004 15:06:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075925194.2029.102.camel@mulgrave>
References: <OF21001894.F77A2C4A-ONC1256E30.006C8B35-C1256E30.006E2DB9@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:55525 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264233AbUBDUGk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2004 15:06:40 -0500
In-Reply-To: <OF21001894.F77A2C4A-ONC1256E30.006C8B35-C1256E30.006E2DB9@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: "Robert J. Adams (jason)" <radams@siscom.net>, EXT / DEVOTEAM VAROQUI Christophe <ext.devoteam.varoqui@sncf.fr>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Wed, 2004-02-04 at 14:58, Martin Peschke3 wrote:
> As there might be several paths to a device identified by a WWPN
> in the form of 2 or more host bus adapters connecting to that WWPN,
> don't you want to mount an FCP device by
> <adapter identifier> + <WWPN> + <FCP_LUN> ?

Actually, I think the question was about WWN, i.e. the EVPD page 0x83
World Wide Name, which uniquely identifies the device independent of
transport.

The answer is that someone needs to think about doing it using udev.

James


