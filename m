From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: 2.6.23-rc9 boot failure (megaraid?)
Date: Thu, 04 Oct 2007 19:55:52 +0900
Message-ID: <20071004195552G.fujita.tomonori@lab.ntt.co.jp>
References: <20071004084651L.fujita.tomonori@lab.ntt.co.jp>
	<20071004072834.GD5236@kernel.dk>
	<20071004104858.GF10852@stusta.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:36160 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbXJDKz4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Oct 2007 06:55:56 -0400
In-Reply-To: <20071004104858.GF10852@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bunk@kernel.org
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, Sumant.Patro@lsi.com, James.Bottomley@SteelEye.com, bwindle@fint.org, linux-kernel@vger.kernel.org, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org

On Thu, 4 Oct 2007 12:48:58 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> On Thu, Oct 04, 2007 at 09:28:34AM +0200, Jens Axboe wrote:
> >...
> > Tomo, this is the patch I added.
> 
> Please excuse my comment in case this was already clear:
> 
> You are aware that this bug is a regression in 2.6.23-rc and the patch 
> should therefore go to Linus ASAP and not after the release of 2.6.23?

Oops, you are right. This should go via scsi-rc-fixes tree ASAP.
