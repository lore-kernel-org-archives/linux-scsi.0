From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 09:48:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707170944320.686@fbirervta.pbzchgretzou.qr>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:25279 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbXGQHsc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 03:48:32 -0400
In-Reply-To: <20070716165706.348f6bbf.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


On Jul 16 2007 16:57, Andrew Morton wrote:
>A belated review (I've never seen this before and there it is in mainline)
>
>> static char bsg_version[] = "block layer sg (bsg) 0.4";
>
>`const' would be better.  That moves it into a write-protected memory section.

Or perhaps MODULE_DESCRIPTION() and MODULE_VERSION()?


	Jan
-- 
