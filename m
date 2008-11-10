From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Thin provisioning & arrays
Date: Mon, 10 Nov 2008 06:30:11 -0700
Message-ID: <20081110133010.GN15439@parisc-linux.org>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <1226072970.15281.46.camel@think.oraclecorp.com> <20081109233639.GT4985@disturbed> <9FA859626025B64FBC2AF149D97C944A8A648D@CORPUSMX80A.corp.emc.com> <20081110083126.GF2373@disturbed> <1226311189.4367.30.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53836 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbYKJNaN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2008 08:30:13 -0500
Content-Disposition: inline
In-Reply-To: <1226311189.4367.30.camel@macbook.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Black_David@emc.com, martin.petersen@oracle.com, chris.mason@oracle.com, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, rwheeler@redhat.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com

On Mon, Nov 10, 2008 at 10:59:49AM +0100, David Woodhouse wrote:
> Storage devices are complex enough that they _already_ exhibit behaviour
> which is fairly much non-deterministic in a number of ways. Especially
> if we're talking about SSDs or large arrays, rather than just disks.

If anything, SSDs are more deterministic than rotating storage.
Variable numbers of sectors per track, unpredictable sector remapping,
track re-reads due to errors during reads ... SSDs seem like a real
improvement.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
