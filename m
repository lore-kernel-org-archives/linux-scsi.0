From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] - fusion - add support for raid hot add/del support
Date: Thu, 26 Jan 2006 19:36:42 +0000
Message-ID: <20060126193642.GA5702@infradead.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F1FED4F@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:47289 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751374AbWAZTgn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2006 14:36:43 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F1FED4F@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, James.Bottomley@SteelEye.com, hch@infradead.org

On Wed, Jan 25, 2006 at 06:05:09PM -0700, Moore, Eric wrote:
> RAID event support.
> 
> This will hot add and remove raid volumes
> when managment application creates and
> deletes the volumes.  The driver is basically
> responding to firmware asyn events, and reporting
> the changes to the above layers.

looks good.
