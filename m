From: john@grabjohn.com
Subject: Re: [RFR] a new SCSI driver
Date: Sun, 25 May 2003 10:44:05 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200305250944.h4P9i5Ct000456@81-2-122-30.bradfords.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 81-2-122-30.bradfords.org.uk ([81.2.122.30]:22400 "EHLO
	81-2-122-30.bradfords.org.uk") by vger.kernel.org with ESMTP
	id S261454AbTEYIYo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 May 2003 04:24:44 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: jgarzik@pobox.com, linux-scsi@vger.kernel.org

> Serial ATA is looming quickly on the horizon.  Both device and host
> controller SATA implementations really lend themselves to behaviors
> that have existed in SCSI for a while.  SATA even defines use of SCSI
> Enclosure Services.

Thinking ahead, by the 2.8 timescale, PATA could well be legacy hardware 
which could be supported only by an 'old' IDE driver, much like we already
have at the moment - I.E. we could remove the current 'old' IDE driver
sometime during the 2.7 timescale, and support SATA only via the SCSI layer.

This would save having any more than the minimum SATA code going in to the
existing IDE driver, and consolidate work in the future.        

The bloat of the SCSI layer in embedded machines might be a concern, but  
then again, maybe it won't - how many embedded machines are going to be   
using SATA, anyway?  Once we move away from spinning disks towards solid
state storage, (which is going to happen first in the embedded market),
will we want to use *ATA or SCSI at all?

John
