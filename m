From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] qla2xxx: fix compilation compile
Date: Sun, 17 Feb 2008 13:04:37 -0800
Message-ID: <20080217210437.GB15268@plap3.qlogic.org>
References: <200802160624.m1G6OgC1027039@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20665 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbYBQVEm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Feb 2008 16:04:42 -0500
Content-Disposition: inline
In-Reply-To: <200802160624.m1G6OgC1027039@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sat, 16 Feb 2008, FUJITA Tomonori wrote:

> scsi/qla2xxx/qla_dfs.c: In function 'qla2x00_dfs_fce_show':
> scsi/qla2xxx/qla_dfs.c:26: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'uint64_t'
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
