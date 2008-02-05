From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Tue, 05 Feb 2008 22:00:03 +0300
Message-ID: <47A8B233.2040503@vlnb.net>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	<1201639331.3069.58.camel@localhost.localdomain>	<47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net>	<1202139015.3096.5.camel@localhost.localdomain>	<47A73C86.3060604@vlnb.net>	<1202144767.3096.38.camel@localhost.localdomain>	<47A7488B.4080000@vlnb.net>	<1202145901.3096.49.camel@localhost.localdomain>	<alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>	<1202151989.11265.576.camel@haakon2.linux-iscsi.org> <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:45235 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006AbYBETAG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 14:00:06 -0500
In-Reply-To: <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Linus Torvalds wrote:
> So just going by what has happened in the past, I'd assume that iSCSI 
> would eventually turn into "connecting/authentication in user space" with 
> "data transfers in kernel space".

This is exactly how iSCSI-SCST (iSCSI target driver for SCST) is 
implemented, credits to IET and Ardis target developers.

Vlad
