From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: some iscsi vendor has been hitting a crash
Date: Fri, 01 Nov 2013 16:14:52 -0700
Message-ID: <1383347692.4216.13.camel@haakon3.risingtidesystems.com>
References: <1382997816.19256.767.camel@haakon3.risingtidesystems.com>
	 <5273BEBF.2090008@cs.wisc.edu> <20131101212816.GA27918@glanzmann.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:46662 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3KAXFb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2013 19:05:31 -0400
In-Reply-To: <20131101212816.GA27918@glanzmann.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi@googlegroups.com, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>

On Fri, 2013-11-01 at 22:28 +0100, Thomas Glanzmann wrote:
> Hello Mike,
> 
> * Mike Christie <michaelc@cs.wisc.edu> [2013-11-01 15:56]:
> > On a related note, some iscsi vendor has been hitting a crash with
> > your tree.
> 
> I hit an 'IO stall' with the tree, but was not able to reproduce this.
> Has this vendor information on it (dmesg, OOPS)? I reverted back to
> RTSOS for production classes that I do not give myself, but will run the
> Nab's tree as soon as I give a VMware class myself in order to reproduce
> the issue and than track it down.
> 

Hey Thomas,

Mike's talking about the WIP scsi-mq -> blk-mq initiator stack here, and
not specifically about anything related to target code.

--nab

