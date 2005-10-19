From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/12]  qla2xxx: Update license.
Date: Wed, 19 Oct 2005 19:22:01 +0100
Message-ID: <20051019182201.GA5913@infradead.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051013231614.27191.9897.sendpatchset@plap.qlogic.com> <1129275031.2873.3.camel@laptopd505.fenrus.org> <20051014162701.GA19098@plap.qlogic.org> <1129315644.5359.7.camel@laptopd505.fenrus.org> <20051019173707.GO9087@plap.qlogic.org> <20051019174312.GA5103@infradead.org> <20051019175009.GQ9087@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:5542 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751210AbVJSSWD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 14:22:03 -0400
Content-Disposition: inline
In-Reply-To: <20051019175009.GQ9087@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Arun Mittal <arun.mittal@qlogic.com>

On Wed, Oct 19, 2005 at 10:50:09AM -0700, Andrew Vasquez wrote:
> Sorry, but QLogic is not requesting that the driver codes be
> dual-licensed.  The license explcitely states the codes are under the
> GPL and the firmware blobs are under the BSD style license.
> 
> Where's the disconnect?

sorry, I mis-read the sentence before the BSD-style license.  This
approach is fine with me, and still required with external firmware
aswell so that the distributions have a chance to ship it.  It would
be nice to just add a the BSD boilerplate to each of the firmware
files directly instead of adding a LICENSE file to avoid confusion
like mine :)

