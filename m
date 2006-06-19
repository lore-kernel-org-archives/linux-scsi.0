From: Chuck Ebbert <76306.1226@compuserve.com>
Subject: Re: BUG: spinlock recursion on CPU, kernel 2.6.16.20 &
  2.6.16-1.2122_FC5[smp]
Date: Mon, 19 Jun 2006 05:57:39 -0400
Message-ID: <200606190600_MC3-1-C2D8-23E5@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain;
	 charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from liaag2aa.mx.compuserve.com ([149.174.40.154]:481 "EHLO
	liaag2aa.mx.compuserve.com") by vger.kernel.org with ESMTP
	id S932321AbWFSKDP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jun 2006 06:03:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konstantin Antselovich <konstantin@antselovich.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

In-Reply-To: <4491933C.7060100@antselovich.com>

On Thu, 15 Jun 2006 10:05:00 -0700, Konstantin Antselovich wrote:

> Jun 10 00:57:35 192.168.0.201 BUG: spinlock recursion on CPU#2, swapper/0
> Jun 10 00:57:35 192.168.0.201  lock: c266f600, .magic: dead4ead, .owner:
> swapper/0, .owner_cpu: 2
> Jun 10 00:57:35 192.168.0.201  [<c01cc02d>]
> Jun 10 00:57:35 192.168.0.201 _raw_spin_lock+0x33/0xd2
> Jun 10 00:57:35 192.168.0.201
> Jun 10 00:57:35 192.168.0.201  [<c02e5bf7>]
> Jun 10 00:57:35 192.168.0.201 _spin_lock_irqsave+0x9/0xd
> Jun 10 00:57:35 192.168.0.201
> Jun 10 00:57:35 192.168.0.201  [<f88b7768>]
> Jun 10 00:57:35 192.168.0.201 ahd_freeze_simq+0x12/0x43 [aic79xx]

Please try 2.6.17.  The spinlock was removed.

-- 
Chuck
 "You can't read a newspaper if you can't read."  --George W. Bush
