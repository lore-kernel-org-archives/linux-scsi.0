From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 04 Mar 2008 19:45:28 +0100
Message-ID: <1204656328.6598.1.camel@homer.simson.net>
References: <20080304093536.GH6704@kernel.dk>
	 <1204634238.5997.5.camel@homer.simson.net>	<47CD4355.4050401@gmail.com>
	 <20080304223006A.tomof@acm.org> <47CD53BA.5040908@gmail.com>
	 <47CD7611.2030606@gmail.com>  <47CD7C05.1080707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43263 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932607AbYCDSpe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 13:45:34 -0500
In-Reply-To: <47CD7C05.1080707@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: FUJITA Tomonori <tomof@acm.org>, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com


On Wed, 2008-03-05 at 01:42 +0900, Tejun Heo wrote:

> The following patch gets the writing going.

Bingo.

	-Mike

