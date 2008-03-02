From: Erez Zilber <erezz@Voltaire.COM>
Subject: Re: [PATCH 0/3] iscsi iser limits
Date: Sun, 02 Mar 2008 15:56:14 +0200
Message-ID: <47CAB1FE.5010207@Voltaire.COM>
References: <20080212205252.GB13643@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:21283 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755018AbYCBN43 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 08:56:29 -0500
In-Reply-To: <20080212205252.GB13643@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Roland Dreier <rolandd@cisco.com>, linux-scsi <linux-scsi@vger.kernel.org>

Pete Wyckoff wrote:
> These three patches remove various block device limits to
> the iSER iSCSI transport.  I guess in theory they should go
> in via the IB tree, although ACKs from the iSCSI side would
> be welcome.
>
> The first two look quite similar to some TCP iSCSI patches
> that Mike applied a while back:
>
>     d1d81c01f4bdd50577d9f89aa4a8e6344f63aa70
> 	[SCSI] iscsi_tcp: remove DMA alignment restriction
>
>     8231f0eddbe425cc3b54f2d723bb03531925272e
> 	[SCSI] iscsi_tcp: increase max_sectors
>
> The third fixes a problem with mapping an unaligned 512 kB
> buffer and takes the opportunity to increase the FMR mapping
> limit to 1 MB, as is done in SRP.
>
>   
Pete,

In the future, please send iSER patches also to
general@lists.openfabrics.org.

Thanks,
Erez
