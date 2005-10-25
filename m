From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.14-rc5-mm1
Date: Tue, 25 Oct 2005 17:13:26 +0100
Message-ID: <20051025161326.GA31122@infradead.org>
References: <20051024014838.0dd491bb.akpm@osdl.org> <1130186927.6831.23.camel@localhost.localdomain> <20051024141646.6265c0da.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40136 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932198AbVJYQNb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Oct 2005 12:13:31 -0400
Content-Disposition: inline
In-Reply-To: <20051024141646.6265c0da.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Badari Pulavarty <pbadari@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Mon, Oct 24, 2005 at 02:16:46PM -0700, Andrew Morton wrote:
> qla2x00_probe_one() has called qla2x00_free_device() and
> qla2x00_free_device() has locked up in
> wait_for_completion(&ha->dpc_exited);

one more reason to use one-for-one goto-style unwinding instead of
calling _free routines ;-)

While we're at it -  Andew, would you converting qla2xxx to the
kthread_ API for thread handling?

