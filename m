From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] target: Change some fabric functions to return bool
Date: Fri, 14 Nov 2014 08:06:04 +0100
Message-ID: <20141114070604.GB3944@lst.de>
References: <1415911858-3123-1-git-send-email-agrover@redhat.com> <1415911858-3123-3-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45369 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330AbaKNHGH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2014 02:06:07 -0500
Content-Disposition: inline
In-Reply-To: <1415911858-3123-3-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org

On Thu, Nov 13, 2014 at 12:50:58PM -0800, Andy Grover wrote:
> The tpg_check_* functions in the fabric_ops struct return 1 or 0,
> so we can make their return type bool. Change fabrics to match.

All these true/false stub sounds like some of them methods should be
optional, and a useful default should be assumed if they aren't present.
