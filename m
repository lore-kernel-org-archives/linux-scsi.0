From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [scsi]: Add offline state checking while dispatch a
 scsi cmd
Date: Sun, 11 Mar 2007 01:53:00 -0800
Message-ID: <20070311015300.271c2323.akpm@linux-foundation.org>
References: <20070308092207.GA17141@joejin-pc.cn.oracle.com>
	<1173369759.3683.1.camel@mulgrave.il.steeleye.com>
	<20070309014040.GA6632@joejin-pc.cn.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41974 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbXCKJxQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Mar 2007 05:53:16 -0400
In-Reply-To: <20070309014040.GA6632@joejin-pc.cn.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, joe.jin@oracle.com, akpm@linux-foundation.org, dgilbert@interlog.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, haobo.zhou@oracle.com

> On Fri, 9 Mar 2007 09:40:40 +0800 Joe Jin <joe.jin@oracle.com> wrote:
> > What's the error you're trying to fix?  scsi_dispatch_cmd() is only
> > called from scsi_request_fn() which already has an equivalent of this
> > check in it just prior to calling dispatch.
> 
> Yeah, I have saw the cheking at scsi_request_fn(), recently we got a crash
> info as following at rhel4 2.6.9-42.0.2.ELsmp,

The 2.6.9 base is very old in mainline terms.  Are you sure the bug hasn't
been fixed in mainline by other means?

