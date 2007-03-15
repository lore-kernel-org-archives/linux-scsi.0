From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 3/7] aacraid: Fix blocking issue with container probing
	function
Date: Thu, 15 Mar 2007 14:25:53 -0500
Message-ID: <1173986753.3379.18.camel@mulgrave.il.steeleye.com>
References: <1173979603.30374.23.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:47315 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932835AbXCOTZ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Mar 2007 15:25:59 -0400
In-Reply-To: <1173979603.30374.23.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Thu, 2007-03-15 at 10:26 -0700, Mark Haverkamp wrote:
> -       fsa_dev_ptr = kmalloc(
> +       fsa_dev_ptr = (struct fsa_dev_info *) kmalloc(

Changes like this are unnecessary since void * under c can be cast to
any pointer ... all they do is clutter up the code.

James


