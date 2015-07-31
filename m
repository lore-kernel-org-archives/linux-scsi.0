From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: add support for START_STOP_UNIT SCSI opcode
Date: Thu, 30 Jul 2015 23:58:25 -0700
Message-ID: <1438325905.16598.19.camel@haakon3.risingtidesystems.com>
References: <1437516477-30554-1-git-send-email-sbaugh@catern.com>
	 <20150723093618.GA5382@infradead.org>
	 <877fpqfr19.fsf@ponos.purestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39234 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbbGaG61 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2015 02:58:27 -0400
In-Reply-To: <877fpqfr19.fsf@ponos.purestorage.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Spencer Baugh <sbaugh@catern.com>
Cc: Christoph Hellwig <hch@infradead.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Joern Engel <joern@purestorage.com>, Brian Bunker <brian@purestorage.com>

On Thu, 2015-07-23 at 15:27 -0700, Spencer Baugh wrote:
> From: Brian Bunker <brian@purestorage.com>
> 
> AIX servers using VIOS servers that virtualize FC cards will have a
> problem booting without support for START_STOP_UNIT.
> 
> v2: Cite sb3r36 exactly, clean up if conditions
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> Signed-off-by: Spencer Baugh <sbaugh@catern.com>
> ---
>  drivers/target/target_core_sbc.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 

Applied to target-pending/for-next with extra sb3 -> sbc3 typo fixup.

Thanks Brian + Spencer!

