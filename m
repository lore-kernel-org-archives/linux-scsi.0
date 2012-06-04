From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: Tree for Jun 1 (scsi)
Date: Sun, 03 Jun 2012 20:31:05 -0700
Message-ID: <4FCC2BF9.7000802@xenotime.net>
References: <20120601132202.ac73b03c845299d384defeaf@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:49011 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755735Ab2FDDbL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jun 2012 23:31:11 -0400
In-Reply-To: <20120601132202.ac73b03c845299d384defeaf@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 05/31/2012 08:22 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120531:



already fixed?

on i386 and x86_64, loadable module or builtin:


ERROR: "scsi_sd_probe_domain" [drivers/scsi/scsi_mod.ko] undefined!
or
(.text+0x4f6c77): undefined reference to `scsi_sd_probe_domain'

-- 

~Randy
(sorry about the delay, was out for 3 days)
