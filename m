From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: scsi_run_queue oops
Date: Fri, 23 Dec 2005 13:14:17 -0700
Message-ID: <20051223201417.GO2361@parisc-linux.org>
References: <20051223201227.GA7020@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:45463 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1161020AbVLWUOV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 15:14:21 -0500
Content-Disposition: inline
In-Reply-To: <20051223201227.GA7020@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Dec 23, 2005 at 03:12:27PM -0500, Dave Jones wrote:
> The user mentions that the workstation is actually diskless, so I'm
> puzzled why we're doing SCSI IO at all, but nevertheless...
> I've asked for more info.

Maybe it has USB storage, or IEE1394, or ...
