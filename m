From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: RE: Help: strange messages from kernel on IA64 platform
Date: Tue, 16 May 2006 14:32:49 -0700
Message-ID: <4t153d$13ldvv@azsmga001.ch.intel.com>
References: <890BF3111FB9484E9526987D912B261901BD86@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1673 "EHLO
	azsmga101-1.ch.intel.com") by vger.kernel.org with ESMTP
	id S932129AbWEPVcu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 17:32:50 -0400
In-Reply-To: <890BF3111FB9484E9526987D912B261901BD86@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'Ju, Seokmann'" <Seokmann.Ju@lsil.com>, Chase Venters <chase.venters@clientec.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Ju, Seokmann wrote on Tuesday, May 16, 2006 2:13 PM
> Tuesday, May 16, 2006 5:00 PM, Chase Venters wrote:
> > It's a trap, which means the CPU is effectively calling that 
> function.
> O.K, that's why...
> Then, Is there anyway to look up trap table that the CPU has?

By looking at the instruction address that triggered the unaligned
fault, it is coming from a kernel module.

You should look at the runtime symbol table /proc/kallsyms and try
to map that ip into a function.

- Ken
