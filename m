From: john@grabjohn.com
Subject: Re: [RFR] a new SCSI driver
Date: Sun, 25 May 2003 13:09:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200305251209.h4PC9NBr000987@81-2-122-30.bradfords.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 81-2-122-30.bradfords.org.uk ([81.2.122.30]:22145 "EHLO
	81-2-122-30.bradfords.org.uk") by vger.kernel.org with ESMTP
	id S261827AbTEYKuS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 May 2003 06:50:18 -0400
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk

> on common misunderstanding ; PATA != PIO mode ATA but Parallel ATA, as
> opposed to Serial ATA

Yes, Parallel ATA is what I was suggesting we moved in to a legacy driver
sometime during the 2.7 timescale.

John.
