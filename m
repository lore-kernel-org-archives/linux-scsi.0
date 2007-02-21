From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: initio.h header user confusion
Date: Wed, 21 Feb 2007 09:20:09 -0700
Message-ID: <20070221162008.GA26111@parisc-linux.org>
References: <Pine.LNX.4.63.0702211558220.5167@thor.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40439 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422649AbXBUQUK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Feb 2007 11:20:10 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0702211558220.5167@thor.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Srdjan Todorovic <todorovic.s@googlemail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Feb 21, 2007 at 04:12:06PM +0000, Srdjan Todorovic wrote:
> So how is it possible that other drivers such as aha1542.c use these defines?

Possibly, they don't.  I just looked at the ncr53c8xx driver, and the
only uses of SCSI_ABORT_* are inside an #if 0 block.  The same is true
for aha1542.
