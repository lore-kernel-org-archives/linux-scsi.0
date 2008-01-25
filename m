From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: INITIO scsi driver fails to work properly
Date: Fri, 25 Jan 2008 10:49:32 -0600
Message-ID: <1201279772.3119.38.camel@localhost.localdomain>
References: <1200070903.3286.28.camel@localhost.localdomain>
	 <9f00bd9d0801130428s5e4c034apf21052b918470f99@mail.gmail.com>
	 <1200410166.9273.4.camel@localhost.localdomain>
	 <20080116145916A.fujita.tomonori@lab.ntt.co.jp>
	 <1200495471.3136.1.camel@localhost.localdomain>
	 <20080121222037.3d8b46a1@lxorguk.ukuu.org.uk>
	 <9f00bd9d0801220950r49de29abl8fbb2495a65c9a10@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33879 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754169AbYAYQtg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2008 11:49:36 -0500
In-Reply-To: <9f00bd9d0801220950r49de29abl8fbb2495a65c9a10@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Filippos Papadopoulos <psybases@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, cebbert@redhat.com, bharrosh@panasas.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 19:50 +0200, Filippos Papadopoulos wrote:
> I get the following:
> SAH
> SSH
> SCB Q
> SCB EXEC
> SCB EXEC DONE

Actually, I suspect your issues should be fixed by this patch:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e2d435ea4084022ab88efa74214accb45b1f9e92

Could you download 2.6.24 and try it out to see if they are?

Thanks,

James


