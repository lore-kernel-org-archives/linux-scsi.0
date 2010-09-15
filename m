From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi, fcoe, libfc: drop scsi host_lock use from fc_queuecommand
Date: Wed, 15 Sep 2010 20:01:32 +0200
Message-ID: <AANLkTimAkGq7NxPCksBXWwY35+cSE6qf+2NfqxCb0QFj@mail.gmail.com>
References: <20100903222715.6237.75737.stgit@localhost.localdomain>
	<AANLkTinVTSboQB=kxyOCQ-eF6hYWqsn9YYJn7bnLeTtW@mail.gmail.com>
	<1284571877.30345.24.camel@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65389 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab0IOSBg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2010 14:01:36 -0400
Received: by pwi3 with SMTP id 3so214600pwi.19
        for <linux-scsi@vger.kernel.org>; Wed, 15 Sep 2010 11:01:36 -0700 (PDT)
In-Reply-To: <1284571877.30345.24.camel@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Vasu Dev <vasu.dev@intel.com>, linux-scsi@vger.kernel.org

On Wed, Sep 15, 2010 at 7:31 PM, Vasu Dev <vasu.dev@linux.intel.com> wrote:
>
> On Sun, 2010-09-12 at 18:37 +0200, Bart Van Assche wrote:
> > On Sat, Sep 4, 2010 at 12:27 AM, Vasu Dev <vasu.dev@intel.com> wrote:
> > > [ ... ]
> > After having converted the SRP initiator (ib_srp) to use per-LUN
> > locking instead of per-host locking and after having enabled
>
> Per-lun locking looks good idea and should mitigate host lock
> bottlenecks while lun is not simultaneously used by all host cores, may
> be some use case would prevent that by limiting lun to VM on specific
> core. Is this change already upstream or queued for upstream ? Is that
> change going to eliminate host lock on fast path completely ?
> [ ... ]

Yes, that patch eliminates the host lock on the fast patch completely.
The patch is not yet available upstream - I still have to split it and
post it for review on the linux-rdma mailing list. But if you want you
can have a look at that patch here:
http://sourceforge.net/mailarchive/message.php?msg_name=E1Ova8J-0005Mx-NV%40sfp-svn-4.v30.ch3.sourceforge.com.

Bart.
