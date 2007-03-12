From: Joe Jin <joe.jin@oracle.com>
Subject: Re: [PATCH] [scsi]: Add offline state checking while dispatch a scsi cmd
Date: Mon, 12 Mar 2007 10:52:22 +0800
Message-ID: <20070312025222.GC32372@joejin-pc.cn.oracle.com>
References: <20070308092207.GA17141@joejin-pc.cn.oracle.com> <1173369759.3683.1.camel@mulgrave.il.steeleye.com> <20070309014040.GA6632@joejin-pc.cn.oracle.com> <20070311015300.271c2323.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:12592 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964838AbXCLCyT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Mar 2007 22:54:19 -0400
Content-Disposition: inline
In-Reply-To: <20070311015300.271c2323.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Jin <joe.jin@oracle.com>, James.Bottomley@SteelEye.com, dgilbert@interlog.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, haobo.zhou@oracle.com

> The 2.6.9 base is very old in mainline terms.  Are you sure the bug hasn't
> been fixed in mainline by other means?

I cannot confirm if it have fixed in latest kernel, the server is a
production system, it's hard to debug it and try reproduce.

