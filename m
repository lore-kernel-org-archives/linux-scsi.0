From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Thin provisioning & arrays
Date: Mon, 10 Nov 2008 14:36:54 +0100
Message-ID: <20081110133653.GH26778@kernel.dk>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <1226072970.15281.46.camel@think.oraclecorp.com> <20081109233639.GT4985@disturbed> <9FA859626025B64FBC2AF149D97C944A8A648D@CORPUSMX80A.corp.emc.com> <20081110083126.GF2373@disturbed> <1226311189.4367.30.camel@macbook.infradead.org> <20081110133010.GN15439@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:39128 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369AbYKJNi1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2008 08:38:27 -0500
Content-Disposition: inline
In-Reply-To: <20081110133010.GN15439@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: David Woodhouse <dwmw2@infradead.org>, Dave Chinner <david@fromorbit.com>, Black_David@emc.com, martin.petersen@oracle.com, chris.mason@oracle.com, James.Bottomley@hansenpartnership.com, rwheeler@redhat.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com

On Mon, Nov 10 2008, Matthew Wilcox wrote:
> On Mon, Nov 10, 2008 at 10:59:49AM +0100, David Woodhouse wrote:
> > Storage devices are complex enough that they _already_ exhibit behaviour
> > which is fairly much non-deterministic in a number of ways. Especially
> > if we're talking about SSDs or large arrays, rather than just disks.
> 
> If anything, SSDs are more deterministic than rotating storage.
> Variable numbers of sectors per track, unpredictable sector remapping,
> track re-reads due to errors during reads ... SSDs seem like a real
> improvement.

This was also discussed at LPC, and I would tend to disagree. On
rotation storage, slight skews here and there are seen, but rarely
anything major. On SSD's, when the GC kicks in it can be fairly
detrimental to performance. And one run doesn't necessarily compare to
the next run, even if you start with the same seed.

-- 
Jens Axboe

