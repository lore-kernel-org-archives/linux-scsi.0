From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] scsi_transport_sas.c - mapping the rphy channel equal
 to the port identifier
Date: Sat, 07 Jan 2006 14:03:36 +0100
Message-ID: <43BFBC28.1@s5r6.in-berlin.de>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F15386F@NAMAIL2.ad.lsil.com> <20060106165421.GA3856@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:22991 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1030437AbWAGNEd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 7 Jan 2006 08:04:33 -0500
In-Reply-To: <20060106165421.GA3856@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Christoph Hellwig wrote:
> On Wed, Jan 04, 2006 at 02:58:40PM -0700, Moore, Eric wrote:
> 
>>The sas transport current implementation is mapping
>>the channel number for each sas/sata device equal to
>>the phy number.  The problem with that is it will be difficult
>>to reserve a channel for RAID volumes when hot swap support
>>is eventually implemented in the sas transport layer.
>>Thus my suggested change is to map the channel to the port 
>>identifier, which effectively maps each channel number to its own
>>unique sas domain.  Thus we can map the RAID volumes to a reserved
>>channel that
>>is one larger than the anticapated number of ports on the direct
>>attached host
>>adapter.
> 
> 
> ACK.  The channel isn't used for anything in the transport class or LLDD,
> so this is fine.

Is it desired to provide content for "channel" in non-SPI transport 
classes, IOW to semantically overload "channel"? (Short term, long term...?)
-- 
Stefan Richter
-=====-=-==- ---= --===
http://arcgraph.de/sr/
