From: Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: RE: Help: strange messages from kernel on IA64 platform
Date: Wed, 17 May 2006 11:08:46 +1000
Message-ID: <17514.30622.22763.24688@wombat.chubb.wattle.id.au>
References: <890BF3111FB9484E9526987D912B261901BD86@NAMAIL3.ad.lsil.com>
	<4t153d$13ldvv@azsmga001.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail25.syd.optusnet.com.au ([211.29.133.166]:42448 "EHLO
	mail25.syd.optusnet.com.au") by vger.kernel.org with ESMTP
	id S1751037AbWEQBI7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 21:08:59 -0400
In-Reply-To: <4t153d$13ldvv@azsmga001.ch.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Cc: "'Ju, Seokmann'" <Seokmann.Ju@lsil.com>, Chase Venters <chase.venters@clientec.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

>>>>> "Kenneth" == Kenneth W Chen <Chen> writes:

Kenneth> Ju, Seokmann wrote on Tuesday, May 16, 2006 2:13 PM
>> Tuesday, May 16, 2006 5:00 PM, Chase Venters wrote: > It's a trap,
>> which means the CPU is effectively calling that function.  O.K,
>> that's why...  Then, Is there anyway to look up trap table that the
>> CPU has?

Kenneth> By looking at the instruction address that triggered the
Kenneth> unaligned fault, it is coming from a kernel module.

General details for tracking down unaligned access problems in IA64
linux at http://www.gelato.unsw.edu.au/IA64wiki/UnalignedAccesses
-- 
Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
http://www.ertos.nicta.com.au           ERTOS within National ICT Australia
