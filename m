From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] - Fusion-MPT much faster as module
Date: Tue, 22 Mar 2005 22:07:43 -0600
Message-ID: <1111550863.5520.92.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C01AEB1F7@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:5351 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262760AbVCWEHw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 23:07:52 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C01AEB1F7@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, kenneth.w.chen@intel.com

On Tue, 2005-03-22 at 13:35 -0700, Moore, Eric Dean wrote:
> I still wonder if the SPI transport layer will work for RAID volumes.  
> Do you know if the spi transport layer supports dv on hidden devices in a
> raid volume? 
> Meaning these hidden physical disks will not been seen by the block layer,
> however 
> spi transport layer would be aware so dv can be performed those hidden disk?

I recall this being discussed, and the conclusion being that we could
allow a flag to bar attachment of the ULD.  So the underlying discs
would have a scsi_device but no sd device.  Then the spi_transport class
will work fine on them but the user wouldn't be able to open them or
mount anything.

James


