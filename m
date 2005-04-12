From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE 2/6] Linux-iSCSI High-Performance Initiator
Date: Tue, 12 Apr 2005 08:27:33 +0100
Message-ID: <20050412072733.GA32354@infradead.org>
References: <425B3F58.2040000@yahoo.com> <20050412053650.GF32372@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:58027 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261975AbVDLH1f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2005 03:27:35 -0400
Content-Disposition: inline
In-Reply-To: <20050412053650.GF32372@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Alex Aizman <itn780@yahoo.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Apr 11, 2005 at 10:36:51PM -0700, Greg KH wrote:
> On Mon, Apr 11, 2005 at 08:24:08PM -0700, Alex Aizman wrote:
> >               Common header files:
> >               - iscsi_ifev.h (user/kernel events).
> 
> These structures cross the user/kernel boundry?  If so, they _must_ use
> the __u32 and friends types, not the horrible uint32_t mess...

No, C99 are just fine.
