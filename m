From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: QLA2xxx on Dell M600
Date: Tue, 24 Feb 2009 07:49:37 -0800
Message-ID: <20090224154937.GB9985@plap4-2.local>
References: <166d01c9966a$f0d6f990$0a00a8c0@ALDI2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:44268 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758AbZBXPtj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Feb 2009 10:49:39 -0500
Content-Disposition: inline
In-Reply-To: <166d01c9966a$f0d6f990$0a00a8c0@ALDI2>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerald Nowitzky <Nowitzky@igne.de>
Cc: Linux Driver <Linux-Driver@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 24 Feb 2009, Gerald Nowitzky wrote:

> I tried to use the qla2xxx on 2.6.28.7 with Dell Blade M600 and QME2472 Mezzanine Card, using x86 / 64 bit.
>
> It OOPSes. The OOPS was introduced with 2.6.27.1 (qla2xxx 8.02.01-k7) . The older 2.6.26.8 (qla2xxx 8.02.01-k4) works fine.

Fixed here for 2.6.29.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7f977ddd0eedfd5aac7865794f220f65aae8f361

We'll push this to stable.

Thanks,
Andrew Vasquez
