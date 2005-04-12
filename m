From: Greg KH <greg@kroah.com>
Subject: Re: [ANNOUNCE 2/6] Linux-iSCSI High-Performance Initiator
Date: Mon, 11 Apr 2005 22:36:51 -0700
Message-ID: <20050412053650.GF32372@kroah.com>
References: <425B3F58.2040000@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:7633 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S262058AbVDLFhI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2005 01:37:08 -0400
Content-Disposition: inline
In-Reply-To: <425B3F58.2040000@yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Aizman <itn780@yahoo.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Apr 11, 2005 at 08:24:08PM -0700, Alex Aizman wrote:
>               Common header files:
>               - iscsi_ifev.h (user/kernel events).

These structures cross the user/kernel boundry?  If so, they _must_ use
the __u32 and friends types, not the horrible uint32_t mess...

thanks,

greg k-h
