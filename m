From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v3] fusion: remove dead MTRR code
Date: Thu, 4 Jun 2015 19:41:34 +0200
Message-ID: <20150604174134.GQ23057@wotan.suse.de>
References: <1429649166-18294-1-git-send-email-mcgrof@do-not-panic.com>
 <CAK=zhgqU7+Dm1ZUhVpGF_QMPAPnnaSbdh18GLajDvJBAXrGCQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58727 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbbFDRli (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jun 2015 13:41:38 -0400
Content-Disposition: inline
In-Reply-To: <CAK=zhgqU7+Dm1ZUhVpGF_QMPAPnnaSbdh18GLajDvJBAXrGCQg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, James Bottomley <JBottomley@Parallels.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>, Andy Lutomirski <luto@amacapital.net>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, mst@redhat.com, Toshi Kani <toshi.kani@hp.com>, Suresh Siddha <sbsiddha@gmail.com>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, Juergen Gross <jgross@suse.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>, Antonino Daplas <adaplas@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, Jun 04, 2015 at 10:20:23AM +0530, Sreekanth Reddy wrote:
> Hi Luis,
> 
> Sorry for delay in response. Actually I was looking for the history of
> this section of code but I couldn't find it. Anyway this is dead code
> and we are fine with removing this dead code.
> 
> James,
> 
> Please consider this patch as:
>
> Acked-by: Sreekanth Reddy <ureekanth.reddy@avagotech.com>

Great thanks, now who's tree should this patch go through? Last patch for this
driver was in 2014 and went through Christoph, but if Christoph doesn't want to
take it can it go through Andrew's tree?

Sreekanth, can you also update the MAINTAINERS file to reflect recent changes
at your company ?

  Luis
