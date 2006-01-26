From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] - scsi_transport_sas.c - display port identifier
Date: Thu, 26 Jan 2006 19:35:27 +0000
Message-ID: <20060126193527.GA5591@infradead.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F1FED4E@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45753 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751022AbWAZTfa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2006 14:35:30 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F1FED4E@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, James.Bottomley@SteelEye.com, hch@infradead.org

On Wed, Jan 25, 2006 at 06:05:07PM -0700, Moore, Eric wrote:
> This patch displays the port identifier on
> the folder attributes; located in the middle digit.
> 
> /sys/class/sas_phy/phy-%x:%x:%x
> /sys/class/sas_rphy/rphy-%x:%x:%x
> 
> The port identifier is basically the unique identifier
> for each sas domain.

The port identifier for a given phy could change when phys are removed from
one port and added to another.  So doing this for the phy is probably
a bad idea.  Doing it for the rphy should be fine because that object gets
removed and recreated in that case.

