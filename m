From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Fix tcm_mod_builder.py default EXTRA_CFLAGS
Date: Tue, 18 Jan 2011 13:46:02 -0800
Message-ID: <1295387162.22813.454.camel@haakon2.linux-iscsi.org>
References: <1295386222-12869-1-git-send-email-nab@linux-iscsi.org>
	 <20110118213604.GA13063@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37504 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1ARVqF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jan 2011 16:46:05 -0500
In-Reply-To: <20110118213604.GA13063@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2011-01-18 at 22:36 +0100, Christoph Hellwig wrote:
> On Tue, Jan 18, 2011 at 01:30:22PM -0800, Nicholas A. Bellinger wrote:
> > +	buf = "EXTRA_CFLAGS += -I$(srctree)/include/ -I$(srctree)/drivers/target/" + fabric_mod_name + "\n\n"
> 
> -I$(srctree)/include/ is never needed, that's added automatically.
> Similarly adding the directory of the driver itself (assuming that's
> what the second one is supposed to be) is not needed either.
> 

This is correct on the -I$(srctree)/include/, and I will drop this as
well..  However with the current fabric module include layout (all .h
living in drivers/target/$FABRIC_MOD), the latter bit is still required
AFAICS to build.

--nab



