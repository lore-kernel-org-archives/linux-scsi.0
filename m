From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6 patch] SCSI: possible cleanups
Date: Tue, 1 Mar 2005 22:17:53 +0000
Message-ID: <20050301221753.GA5742@infradead.org>
References: <20050228213159.GO4021@stusta.de> <4224245E.6090503@torque.net> <42247EF0.9000404@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:20885 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262088AbVCAWR7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 17:17:59 -0500
Content-Disposition: inline
In-Reply-To: <42247EF0.9000404@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: dougg@torque.net, Adrian Bunk <bunk@stusta.de>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Mar 01, 2005 at 09:40:48AM -0500, Luben Tuikov wrote:
> On 03/01/05 03:14, Douglas Gilbert wrote:
> >>  - scsi_error.c: scsi_normalize_sense
> >
> >
> >I introduced scsi_normalize_sense() recently, Christoph H.
> >proposed it should be static but Luben Tuikov (aic7xxx
> >maintainer) said he wished to use it in the future.
> >Hence it was left global.
> 
> Hi guys,
> 
> I think the idea of normalized sense is very good.
> Basically the question is if LLDD would submit normalized
> sense to SCSI Core or whether they would submit a pointer
> to raw sense data as returned by the device and let SCSI
> Core decipher it.
> 
> If the former, then it should be global, if the latter then
> it should be static to SCSI Core.

Doing it in the core means less duplication and avoiding updating
all drivers.

