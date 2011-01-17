From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] target_core_mib.h move
Date: Mon, 17 Jan 2011 15:51:30 -0500
Message-ID: <20110117205130.GA22532@infradead.org>
References: <AANLkTim-KKyOt_U2cDvfW3cav9F29mSvzAcV9H2mJqbT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43302 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1AQUvb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jan 2011 15:51:31 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTim-KKyOt_U2cDvfW3cav9F29mSvzAcV9H2mJqbT@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fubo Chen <fubo.chen@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On Mon, Jan 17, 2011 at 09:00:02PM +0100, Fubo Chen wrote:
> target_core_mib.h move from drivers/target to include/target.
> Otherwise my driver not build.
> 
> Signed-off-by: Fubo Chen <fubo.chen@gmail.com>

Why does the driver need to poke into the target MIB code directly?

Can you post the driver?

