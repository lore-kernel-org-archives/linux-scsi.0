From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: ibmvscsi on powerpc allmodconfig
Date: Sun, 06 Aug 2006 11:21:25 -0500
Message-ID: <1154881285.3683.226.camel@mulgrave.il.steeleye.com>
References: <20060805182514.94f43009.akpm@osdl.org>
	 <20060806111726D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:50378 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750797AbWHFQXD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Aug 2006 12:23:03 -0400
In-Reply-To: <20060806111726D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mike Christie <michaelc@cs.wisc.edu>, akpm@osdl.org, linux-scsi@vger.kernel.org, anton@samba.org, paulus@samba.org

On Sun, 2006-08-06 at 11:17 +0900, FUJITA Tomonori wrote:
> That's a target driver. Sorry, it's my fault. The problem is that the
> scsi-target git tree on kernel.org doesn't include the latest target
> code.

Well, probably mine too ... I thought I understood that post-OLS Mike
Christie would take over doing the target tree on kernel.org, and so you
wouldn't need the one I was maintaining ... is that still the plan?

James


