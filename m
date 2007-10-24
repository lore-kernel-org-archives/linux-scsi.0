From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Target mode support for qlogic chipsets isp2422/2432/5422/5432
Date: Wed, 24 Oct 2007 09:05:46 +0900
Message-ID: <20071024090546S.fujita.tomonori@lab.ntt.co.jp>
References: <3b8510d80710230117l269c6356uff350caeb1ee0e31@mail.gmail.com>
	<20071023180302Y.fujita.tomonori@lab.ntt.co.jp>
	<471E09BE.2030302@qlogic.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:56026 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbXJXAHe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Oct 2007 20:07:34 -0400
In-Reply-To: <471E09BE.2030302@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com
Cc: fujita.tomonori@lab.ntt.co.jp, thayumk@gmail.com, linux-scsi@vger.kernel.org

On Tue, 23 Oct 2007 07:48:30 -0700
Seokmann Ju <seokmann.ju@qlogic.com> wrote:

> FUJITA Tomonori wrote:
> > On Tue, 23 Oct 2007 13:47:20 +0530
> > "Thayumanavar Sachithanantham" <thayumk@gmail.com> wrote:
> > 
> >> Hi All,
> >>
> >> Does the recent target mode support added for tgt support target mode
> >> for qla chipset (qla24xx series)?
> > 
> > We've been trying:
> > 
> > http://marc.info/?t=118857986700004&r=1&w=2
> > 
> > But I heard that the qla24xx firmware doesn't support target mode (I
> > use QLA2340).
> Hello Tomonori,
> The qla24xx firmware supports target mode.
> If I led you to that direction, please forgive me.

No, you didn't.


> When I was verifying the patch, I was confused about the patch and
> thought it already had support for 24xx.  Now, I've verified the
> patch with 23xx and I'm in the middle of adding support for 24xx to
> the patch. I will get back to you as I get it done.

Great! Thanks.
