From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] mark qlogicisp broken
Date: Thu, 10 Feb 2005 10:30:46 -0800
Message-ID: <20050210183046.GA16753@us.ibm.com>
References: <20050210181851.GC11818@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e34.co.us.ibm.com ([32.97.110.132]:19446 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S262192AbVBJSck
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2005 13:32:40 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j1AIWCBu112938
	for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2005 13:32:21 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1AIW36H286812
	for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2005 11:32:05 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j1AIW2v8016786
	for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2005 11:32:03 -0700
Content-Disposition: inline
In-Reply-To: <20050210181851.GC11818@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Thu, Feb 10, 2005 at 07:18:51PM +0100, Christoph Hellwig wrote:
> It's lacking EH support and the hardware is supported by the qla1280
> driver now.

Can we instead remove this one and the qlogicfc?

-- Patrick Mansfield
