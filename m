From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] kill aac_io_done
Date: Mon, 11 Oct 2004 08:48:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097509717.6040.6.camel@markh1.pdx.osdl.net>
References: <20041009134657.GA20075@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:8346 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S269119AbUJKPsu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 11:48:50 -0400
In-Reply-To: <20041009134657.GA20075@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, jejb@steeleye.com, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2004-10-09 at 06:46, Christoph Hellwig wrote:
> there's not need anymore to take the host lock before calling ->done

I have wondered about this.  Was the host lock needed at one time in the
past?

Mark.

> 

-- 
Mark Haverkamp <markh@osdl.org>

