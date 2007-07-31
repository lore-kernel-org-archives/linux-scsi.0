From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: git-scsi-misc build error
Date: Tue, 31 Jul 2007 15:41:34 -0700
Message-ID: <20070731154134.ccea0265.akpm@linux-foundation.org>
References: <20070731152732.ae8d251d.akpm@linux-foundation.org>
	<1185921052.3468.51.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755030AbXGaWlo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jul 2007 18:41:44 -0400
In-Reply-To: <1185921052.3468.51.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: FUJITA Tomonori <tomof@acm.org>, linux-scsi@vger.kernel.org

On Tue, 31 Jul 2007 17:30:52 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Tue, 2007-07-31 at 15:27 -0700, Andrew Morton wrote:
> > ERROR: "scsi_tgt_it_nexus_create" [drivers/scsi/scsi_transport_srp.ko] undefined!
> > ERROR: "scsi_tgt_it_nexus_destroy" [drivers/scsi/scsi_transport_srp.ko] undefined!
> > 
> > This bug was reported about seven times against 2.6.23-rc1-mm1's
> > git-scsi-target, and now it has been moved into git-scsi-misc.
> 
> Yes ... Tomo's on the hook for a better fix, which is promised.
> 

mutter.

Please, nothing which uses Kconfig `select'.  They regularly go wrong.

Please copy me on that fix so I know when to drop this one.
