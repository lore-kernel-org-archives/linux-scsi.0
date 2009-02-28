From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] : Spinning up disk is observed on standby paths until timeout, resulting in longer path restoration time.
Date: Sat, 28 Feb 2009 14:26:25 -0700
Message-ID: <20090228212625.GR16891@parisc-linux.org>
References: <DB8E544DD4B3D346A36F2698103530AE292A9BDC54@GVW1105EXC.americas.hpqcorp.net> <1235144182.3349.5.camel@localhost.localdomain> <20090220155221.GU16841@parisc-linux.org> <1235145795.9025.4.camel@localhost.localdomain> <20090220161334.GV16841@parisc-linux.org> <1235147048.9025.9.camel@localhost.localdomain> <20090220170431.GW16841@parisc-linux.org> <DB8E544DD4B3D346A36F2698103530AE292ABB05C1@GVW1105EXC.americas.hpqcorp.net> <1235400748.3361.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55782 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbZB1V0m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Feb 2009 16:26:42 -0500
Content-Disposition: inline
In-Reply-To: <1235400748.3361.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Rengarajan, Narayanan (STSD)" <narayanan.rengarajan@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Feb 23, 2009 at 08:52:28AM -0600, James Bottomley wrote:
> On Mon, 2009-02-23 at 11:48 +0000, Rengarajan, Narayanan (STSD) wrote:
> > If this patch is valid , when can we expect this on mainstream
> > kernel . I can help testing this patch when included in the kernel.
> 
> If you could test it and report that it works, probably fairly
> immediately.

Narayanan reported that the patch I sent worked, but it wasn't in the push
to Linus you just sent.  I'm not quite sure whether 'fairly immediately'
meant 'for 2.6.29' or 'for 2.6.30', so I don't know whether this was an
oversight or an intentional omission.  In case it was the former, I'm
alerting you to it ;-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
