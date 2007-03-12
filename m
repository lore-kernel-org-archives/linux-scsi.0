From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [scsi]: Add offline state checking while dispatch a
 scsi cmd
Date: Sun, 11 Mar 2007 19:15:29 -0800
Message-ID: <20070311191529.e96ca324.akpm@linux-foundation.org>
References: <20070308092207.GA17141@joejin-pc.cn.oracle.com>
	<1173369759.3683.1.camel@mulgrave.il.steeleye.com>
	<20070309014040.GA6632@joejin-pc.cn.oracle.com>
	<20070311015300.271c2323.akpm@linux-foundation.org>
	<20070312025222.GC32372@joejin-pc.cn.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37778 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964875AbXCLDPi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Mar 2007 23:15:38 -0400
In-Reply-To: <20070312025222.GC32372@joejin-pc.cn.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: joe.jin@oracle.com, James.Bottomley@SteelEye.com, dgilbert@interlog.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, haobo.zhou@oracle.com

> On Mon, 12 Mar 2007 10:52:22 +0800 Joe Jin <joe.jin@oracle.com> wrote:
> > The 2.6.9 base is very old in mainline terms.  Are you sure the bug hasn't
> > been fixed in mainline by other means?
> 
> I cannot confirm if it have fixed in latest kernel, the server is a
> production system, it's hard to debug it and try reproduce.

Well.  That makes it hard to run tests, but perhaps it can be determined
from code review..
