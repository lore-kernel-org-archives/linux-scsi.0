From: Arjan van de Ven <arjan@infradead.org>
Subject: RE: [PATCH] aacraid: Add likely() and unlikely()
Date: Wed, 28 Mar 2007 06:17:39 -0700
Message-ID: <1175087859.6469.17.camel@laptopd505.fenrus.org>
References: <a02278b00703270917w5dcaaf25y92e31dfd6e920b91@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43793 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbXC1NSG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Mar 2007 09:18:06 -0400
In-Reply-To: <a02278b00703270917w5dcaaf25y92e31dfd6e920b91@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Allexio Ju <allexio.ju@gmail.com>
Cc: mark_salyzyn@adaptec.com, linux-scsi@vger.kernel.org

On Tue, 2007-03-27 at 09:17 -0700, Allexio Ju wrote:
> On Thu, 2007-03-22 at 2007 2:24 AM, Arjan van de Ven wrote:
> > (I assume you're aware that likely/unlikely should only be
> > used for 99:1 or higher ratios, this one looks correct for sure)
> Could you share details of reasons why those macros should be used in the way?
> I thought those macros simply tell compiler to layout code in such a
> way that minimizes unnecessary jumps.


it's more than that. it generally also tells the processor what the
branch will be, at which point most processors disable their own branch
prediction logic. Trying to hand-layout code is almost always a
mistake... don't do that. GCC also is quite good at recognizing certain
patterns to keep the code flow working. Trying to override that only
hurts...
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

