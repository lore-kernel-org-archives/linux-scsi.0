From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFR] a new SCSI driver
Date: Sun, 25 May 2003 09:21:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ED0C364.3020507@pobox.com>
References: <200305250944.h4P9i5Ct000456@81-2-122-30.bradfords.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:28545 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262098AbTEYNIx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 May 2003 09:08:53 -0400
In-Reply-To: <200305250944.h4P9i5Ct000456@81-2-122-30.bradfords.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: john@grabjohn.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

john@grabjohn.com wrote:
>>Serial ATA is looming quickly on the horizon.  Both device and host
>>controller SATA implementations really lend themselves to behaviors
>>that have existed in SCSI for a while.  SATA even defines use of SCSI
>>Enclosure Services.
> 
> 
> Thinking ahead, by the 2.8 timescale, PATA could well be legacy hardware 
> which could be supported only by an 'old' IDE driver, much like we already
> have at the moment - I.E. we could remove the current 'old' IDE driver
> sometime during the 2.7 timescale, and support SATA only via the SCSI layer.
> 
> This would save having any more than the minimum SATA code going in to the
> existing IDE driver, and consolidate work in the future.        


I'm content to let evolution make these decisions...  predicting into 
the future isn't the best skill a technologist has :)

	Jeff



