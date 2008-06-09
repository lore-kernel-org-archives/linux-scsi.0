From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Mon, 09 Jun 2008 10:17:11 +0200
Message-ID: <87lk1fqayg.fsf@basil.nowhere.org>
References: <20080604235053K.fujita.tomonori@lab.ntt.co.jp>
	<da824cf30806041106p1de2355fg38594fcb9dcbf203@mail.gmail.com>
	<20080606202119.GQ15085@il.ibm.com>
	<da824cf30806061428t4b7ed816i74d961946d77c88b@mail.gmail.com>
	<20080606213659.GC15085@il.ibm.com>
	<da824cf30806061451p4005a4ecoa9af8687e3ec51e5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:17723 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbYFIISv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 04:18:51 -0400
In-Reply-To: <da824cf30806061451p4005a4ecoa9af8687e3ec51e5@mail.gmail.com> (Grant Grundler's message of "Fri, 6 Jun 2008 14:51:17 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, mgross@linux.intel.com, linux-scsi@vger.kernel.org

"Grant Grundler" <grundler@google.com> writes:
>
> The historical DMA mapping "failure mode" is a kernel panic.  Resizing or

Hasn't been for a long time, except in some extreme cases.  All drivers
are expected to check return values for a long time now.

-Andi
