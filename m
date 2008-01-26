From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: on patch "[SCSI] relax scsi dma alignment"
Date: Sat, 26 Jan 2008 19:49:07 +0100
Message-ID: <479B80A3.5070207@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:36071 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYAZStT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Jan 2008 13:49:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On commit 465ff3185e0cb76d46137335a4d21d0d9d3ac8a2:
> This patch relaxes the default SCSI DMA alignment from 512 bytes to 4
> bytes.  I remember from previous discussions that usb and firewire have
> sector size alignment requirements, so I upped their alignments in the
> respective slave allocs.
[...]
>  drivers/ata/libata-scsi.c      |    5 ++++-
>  drivers/firewire/fw-sbp2.c     |    6 ++++++
>  drivers/ieee1394/sbp2.c        |    6 ++++++
>  drivers/scsi/scsi_lib.c        |    8 ++++++++
>  drivers/usb/storage/scsiglue.c |   20 ++++++++++----------
>  5 files changed, 34 insertions(+), 11 deletions(-)

No, FireWire only requires 4 bytes alignment.

I will channel a reversion of the firewire and ieee1394 hunks through
linux1394-2.6.git for 2.6.26.
-- 
Stefan Richter
-=====-==--- ---= ==-=-
http://arcgraph.de/sr/
