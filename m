From: Dave Jones <davej@redhat.com>
Subject: Re: scsi_run_queue oops
Date: Fri, 23 Dec 2005 15:20:00 -0500
Message-ID: <20051223202000.GB7020@redhat.com>
References: <20051223201227.GA7020@redhat.com> <20051223201417.GO2361@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:2974 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1161035AbVLWUUC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 15:20:02 -0500
Content-Disposition: inline
In-Reply-To: <20051223201417.GO2361@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Fri, Dec 23, 2005 at 01:14:17PM -0700, Matthew Wilcox wrote:
 > On Fri, Dec 23, 2005 at 03:12:27PM -0500, Dave Jones wrote:
 > > The user mentions that the workstation is actually diskless, so I'm
 > > puzzled why we're doing SCSI IO at all, but nevertheless...
 > > I've asked for more info.
 > 
 > Maybe it has USB storage, or IEE1394, or ...

This is happening early during boot up, so I'd be surprised.
(Reporter didn't mention anything exotic like that either,
 but the details were a bit light, so maybe.)

		Dave

