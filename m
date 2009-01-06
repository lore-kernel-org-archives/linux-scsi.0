From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 07/18] osd_ktests: Add basic OSD tests
Date: Tue, 06 Jan 2009 19:04:33 +0200
Message-ID: <49638F21.6080000@panasas.com>
References: <49637117.50108@panasas.com>	<20090107001206N.fujita.tomonori@lab.ntt.co.jp>	<49637D70.1060709@panasas.com> <20090107015837W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:21712 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750907AbZAFREi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 12:04:38 -0500
In-Reply-To: <20090107015837W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, osd-dev@open-osd.org, akpm@linux-foundation.org

FUJITA Tomonori wrote:
> 
> IMHO, it's better to have only useful debugging stuff in mainline for
> many people like scsi_debug.

Believe me, for any one who is using OSD this stuff is a must
just as scsi_debug.

Since everybody will run OSD in 10 years then this is very useful,
right? ;)

Anyway it is removed.

Boaz
