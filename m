From: "Ju, Seokmann" <sju@lsil.com>
Subject: RE: 2.6.10-rc4 tape slow after switch Fusion MPT to Megaraid
Date: Thu, 24 Feb 2005 16:45:28 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57036626F0@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Received: from mail0.lsil.com ([147.145.40.20]:39914 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262489AbVBXVqE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Feb 2005 16:46:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Gerhard Schneider' <gs@ilsb.tuwien.ac.at>, linux-scsi@vger.kernel.org

On Wednesday, February 23, 2005 6:45 AM, Gerhard wrote:
> To: linux-scsi@vger.kernel.org
> Subject: 2.6.10-rc4 tape slow after switch Fusion MPT to Megaraid
> 
> 
> Kernel: 2.6.10-rc4 w/ 3 tape patches from Kai Makisara
I'm not sure, but have you tried without those patches?

> 
> SCSI: 53C1030 controller, tape drive is on one channel of the
> controller.
> 
> Tape: Overland Changer w/ Seagate LTO-1 drive
> Typical transfer speed: 12MB/s
> 
> After adding a Megaraid Zero Channel Raid Controller to that
> computer the transfer speed of the tape changed to 2.6 MB/s
What is driver version that you are using?

Thanks,
Seokmann
LSI Logic Corporation.
