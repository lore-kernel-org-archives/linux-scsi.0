From: Andrew Morton <akpm@osdl.org>
Subject: Re: Fw: 2.5.75 - ppa unload PATCH and remaining problem
Date: Sun, 13 Jul 2003 15:56:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030713155612.37c7662b.akpm@osdl.org>
References: <20030713141556.13650fdb.akpm@osdl.org>
	<20030713234523.A7172@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:58271 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S270423AbTGMWlR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jul 2003 18:41:17 -0400
In-Reply-To: <20030713234523.A7172@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, arvidjaar@mail.ru

Christoph Hellwig <hch@infradead.org> wrote:
>
> On Sun, Jul 13, 2003 at 02:15:56PM -0700, Andrew Morton wrote:
> > sda: Mode Sense: 39 00 10 08
> > SCSI device sda: drive cache: write through
> >  /dev/scsi/host0/bus0/target4/lun0: p4
> > Releasing ppa0
> > Iomega VPI0 (ppa) interface did not call scsi_unregister
> 
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Look at Andrey's report.  His patch adds the scsi_unregister() call.

Then the thing oopses.
