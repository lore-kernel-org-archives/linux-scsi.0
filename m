From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] microtek.c - use data accessors and !use_sg cleanup
Date: Thu, 12 Jul 2007 17:01:09 +0300
Message-ID: <46963425.8050300@panasas.com>
References: <468BE4CE.80402@panasas.com> <200707121529.35512.oliver@neukum.org> <1184248444.3402.0.camel@localhost.localdomain> <200707121556.58706.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:8554 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764312AbXGLOBU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 10:01:20 -0400
In-Reply-To: <200707121556.58706.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

Oliver Neukum wrote:
> 
> Thanks. Which tree should I test against? Where do I get it?
> 
> 	Regards
> 		Oliver
> 

git-clone git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git scsi-misc-2.6

Boaz
