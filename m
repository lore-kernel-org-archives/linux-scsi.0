From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] aacraid: handle AIF hotplug events
Date: Tue, 13 Sep 2005 11:03:10 +0100
Message-ID: <20050913100310.GA30375@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01919BB9@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:32231 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932484AbVIMKDQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 06:03:16 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01919BB9@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Sep 12, 2005 at 07:10:05AM -0400, Salyzyn, Mark wrote:
> Christoph Hellwig [mailto:hch@infradead.org] writes:
>  
> >> +			if (busy == 0) {
> >> +				device->removable = 1;
> > devce->removeable means the device has a removable medium, not that
> > it can go away.
> 
> It also means that the capacity can change. The SCSI subsystem will
> cache the partition table and capacity for the device if this is not

please submit a patch to split ->removable into one flag for removal dervices
and one for those that allow underlying volume changes.

Usage of ->removable as-is is defintelitly wrong.
