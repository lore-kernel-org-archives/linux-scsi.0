From: Jeremy Linton <jli@greshamstorage.com>
Subject: Re: What is Target Mode in SATA terminology?
Date: Mon, 9 Oct 2006 22:15:20 -0500
Message-ID: <200610092215.20396.jli@greshamstorage.com>
References: <1160423279.27817.4.camel@home-desk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from austin.greshamstorage.com ([216.143.252.250]:59666 "EHLO
	austin.greshamstorage.com") by vger.kernel.org with ESMTP
	id S964921AbWJJDpZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Oct 2006 23:45:25 -0400
In-Reply-To: <1160423279.27817.4.camel@home-desk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sean Bruno <sean.bruno@dsl-only.net>
Cc: linux-scsi@vger.kernel.org

On Monday 09 October 2006 14:47, Sean Bruno wrote:
> Just curious...with certain SCSI cards I could implement and play around
> with the card in 'target mode' and hook it up to a separate PC and it
> would appear as a SCSI disk.  Kind of fun to play with.
	You should look at the scst http://scst.sourceforge.net/ project. That is 
where the target mode fun happens. If your serious get a qla22xx card, that 
appears to be the best supported by the project. 


>
> Is there an equivalent in SATA / SAS land?  If there is, is there a well
> supported PCI-(E/X) board out there that I could play with?
	Well, the MPT driver for scst should support SAS. I can tell you though that 
the MPT driver isn't exactly stable for SPI..
