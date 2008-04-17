From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/3 ver3] scsi: varlen extended and vendor-specific cdbs
Date: Thu, 17 Apr 2008 22:04:52 +0900
Message-ID: <20080417220450J.tomof@acm.org>
References: <48059F51.9060401@panasas.com>
	<20080417123224X.tomof@acm.org>
	<480741B3.2080709@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:39929 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758546AbYDQNIv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Apr 2008 09:08:51 -0400
In-Reply-To: <480741B3.2080709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, bzolnier@gmail.com, agk@redhat.com, Geert.Uytterhoeven@sonycom.com

On Thu, 17 Apr 2008 15:25:23 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
>   Add support for variable-length, extended, and vendor specific
>   CDBs to scsi-ml. It is now possible for initiators and ULD's
>   to issue these types of commands. LLDs need not change much.
>   All they need is to raise the .max_cmd_len to the longest command
>   they support (see iscsi patch).
> 
>   - clean-up some code paths that did not expect commands to be
>     larger than 16, and change cmd_len members' type to short as
>     char is not enough.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> Signed-off-by: Benny Halevy <bhalevy@panasas.com>
> ---
>  block/scsi_ioctl.c       |    5 ++---
>  drivers/scsi/constants.c |   10 +++-------
>  drivers/scsi/scsi.c      |   15 ++++-----------
>  drivers/scsi/scsi_lib.c  |    2 +-
>  include/scsi/scsi.h      |   40 +++++++++++++++++++++++++++++++++-------
>  include/scsi/scsi_cmnd.h |    2 +-
>  include/scsi/scsi_host.h |    8 +++-----
>  7 files changed, 47 insertions(+), 35 deletions(-)

looks fine to me though I've not tested it.
