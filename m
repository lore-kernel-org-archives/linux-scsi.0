From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid changes for 2.4.24 kernel to ride through SCSI hang ?
Date: Fri, 13 Feb 2004 20:36:33 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040213203632.A19671@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F25528E@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:12810 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267203AbUBMUge (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 15:36:34 -0500
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F25528E@otce2k03.adaptec.com>; from mark_salyzyn@adaptec.com on Fri, Feb 13, 2004 at 01:56:40PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Feb 13, 2004 at 01:56:40PM -0500, Salyzyn, Mark wrote:
> This patch allows the system to ride through an Adapter that is
> temporarily reticent to commands.
> 
> The cause of this reticence is usually a combination of a Fast Host
> Processors loading up the adapter full with commands and a less than
> perfect SCSI cable or drive triggering an Adapter Cache Flush operation.
> Some Adapters with large cache configuration have been clocked as being
> unresponsive for more than 90 seconds.
> 
> When the SCSI subsystem times out and asks for the Adapter to be reset,
> we wait a minute longer for the Adapter to complete all outstanding
> commands before giving up and returning to the SCSI layers recovery
> code. Without this delay, the first test unit ready issued to the device
> times out and the device is taken offline; usually resulting in a panic
> of the filesystem driver.

Patch looks okay, what about a 2.6 version as we usually require that
for 2.4 updates these days?

