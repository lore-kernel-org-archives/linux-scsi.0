From: David Miller <davem@davemloft.net>
Subject: Re: Query regarding modifying the DMA Mask based on the available
 memory in the system
Date: Thu, 17 Apr 2008 01:43:11 -0700 (PDT)
Message-ID: <20080417.014311.133481790.davem@davemloft.net>
References: <5AE055B67BB5764693E2900C7E3699BE010CAB76@pamail.ad.lsil.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59238
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756402AbYDQInM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Apr 2008 04:43:12 -0400
In-Reply-To: <5AE055B67BB5764693E2900C7E3699BE010CAB76@pamail.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya.Prakash@lsi.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Date: Thu, 17 Apr 2008 16:40:43 +0800

> I am not sure whether this change works fine? I couldn't see any SCSI
> driver using the si_meminfo and this function seems not to return the
> physical layout of the memory. 

Physical addressing has no connection with the types of addresses
that IOMMU based systems will give you, which are virtual and
can be above 4GB on 64-bit systems.
