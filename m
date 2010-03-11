From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: RE: [RFC PATCH] scsi_transport_fc: Make sure commands are
 completed when rport is offline
Date: Thu, 11 Mar 2010 09:52:19 +0900
Message-ID: <20100311095206Q.fujita.tomonori@lab.ntt.co.jp>
References: <1FB7DC5E34DADB499463B6EA89DF40A4638369F937@MNEXMB1.qlogic.org>
	<4B965E15.8040103@emulex.com>
	<1FB7DC5E34DADB499463B6EA89DF40A4638369F9EB@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:57430 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932973Ab0CKAwi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2010 19:52:38 -0500
In-Reply-To: <1FB7DC5E34DADB499463B6EA89DF40A4638369F9EB@MNEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sarang.radke@qlogic.com
Cc: james.smart@Emulex.Com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, lalit.chandivade@qlogic.com, giridhar.malavali@qlogic.com, ravi.anand@qlogic.com

On Wed, 10 Mar 2010 04:03:04 -0600
Sarang Radke <sarang.radke@qlogic.com> wrote:

> James S./Fujita,
> 
> Thanks for the comments. The description of scenario was the one with which I noted the issue. But yes, the same would be true for any rport which is offline.
> 
> I am resending the patch with the suggested modifications.
> 
> -Thanks,
> Sarang
> 
> From 84a1f847c71382f67f97ea956b2283cf6d737340 Mon Sep 17 00:00:00 2001
> From: Sarang Radke <sarang.radke@qlogic.com>
> Date: Tue, 9 Mar 2010 12:20:29 -0500
> Subject: [PATCH] Make sure commands are completed for offline rport
> 
> blk_end_request doesn't complete a bidi request
> successfully
> 
> The unfinished request eventually triggers a panic in
> timeout handling routine fc_bsg_job_timeout as
> req->special is NULL
> 
> Use blk_end_request_all to end the request unconditionally
> 
> Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
> ---
>  drivers/scsi/scsi_transport_fc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


Thanks,
