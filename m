From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH 3/10] add scsi_execute_async and scsi helpers
Date: Tue, 8 Nov 2005 15:05:50 -0800
Message-ID: <20051108230550.GA26528@us.ibm.com>
References: <1131444398.23111.64.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:25494 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1030397AbVKHXFx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Nov 2005 18:05:53 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA8N5rt0026102
	for <linux-scsi@vger.kernel.org>; Tue, 8 Nov 2005 18:05:53 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jA8N5ouN022702
	for <linux-scsi@vger.kernel.org>; Tue, 8 Nov 2005 16:05:50 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id jA8N5qVm029178
	for <linux-scsi@vger.kernel.org>; Tue, 8 Nov 2005 16:05:52 -0700
Content-Disposition: inline
In-Reply-To: <1131444398.23111.64.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: axboe@suse.de, linux-scsi@vger.kernel.org

On Tue, Nov 08, 2005 at 04:06:38AM -0600, Mike Christie wrote:

> +
> +	sioc = kzalloc(sizeof(*sioc), gfp);
> +	if (!sioc)
> +		return DRIVER_ERROR << 24;

I know we don't have one today for scsi_request, but should we use a kmem
cache for these?

-- Patrick Mansfield
