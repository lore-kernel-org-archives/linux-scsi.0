From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: errors from mptsas
Date: Wed, 9 Apr 2008 09:11:29 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229FBDC71@NAMAIL2.ad.lsil.com>
References: <20080409105343.GA19104@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48569 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbYDIPM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2008 11:12:27 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080409105343.GA19104@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>, Rick Warner <rick@microway.com>
Cc: linux-scsi@vger.kernel.org

On Wednesday, April 09, 2008 4:54 AM,  Rick Warner wrote:
> 
> Join the club.  I have an LSI SAS with 3x 750gb seagate sata drives in
> raid5.  Does this happen only on your SATA drives or all the drives?
> Depending on the activity, it would drop one of them out of the
> array.  I think the problem has been solved for now by changing the
> queue_depth to 1.
> 
> echo 1 > /sys/block/sdX/device/queue_depth
> 
> Here's the drives in my system:
> [0:0:0:0]    disk    ATA      ST3750640AS      E     /dev/sda
> [0:0:1:0]    disk    ATA      ST3750640AS      E     /dev/sdb
> [0:0:2:0]    disk    ATA      ST3750640AS      E     /dev/sdc
> 


Rick - I thought you said the magic number was 32 for SATA devices?  And
we confirmed that in the logs you sent yesterday.   Is that correct, or
did I miss something.

Eric
