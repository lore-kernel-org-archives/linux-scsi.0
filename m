From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 1/6] mpt fusion - fibre channel target
	discovery	prematurely terminates
Date: Mon, 22 May 2006 12:57:13 -0500
Message-ID: <1148320633.3320.60.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D7011BBDE@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:13003 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751102AbWEVR5X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 13:57:23 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7011BBDE@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: Michael Reed <mdr@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2006-05-22 at 11:45 -0600, Moore, Eric wrote:
> Anyways ... if were going to sleep, I'd rather the sleeping/waiting be
> done
> from mpt_config when were are calling mpt_get_msg_frame(), instead
> of the calling functions. Perhaps mpt_get_msg_frame triggering a
> signal
> or something when its having a freed mf.

That would be the perfect solution ... if you can guarantee that
mpt_config always has user context, that is.

James


