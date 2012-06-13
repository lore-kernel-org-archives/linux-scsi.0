From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: ERROR: "target_emulate_set_target_port_groups"
 [drivers/target/target_core_pscsi.ko] undefined!
Date: Tue, 12 Jun 2012 21:09:42 -0700
Message-ID: <1339560582.13709.234.camel@haakon2.linux-iscsi.org>
References: <20120613023816.GA24955@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49422 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2FMEJo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jun 2012 00:09:44 -0400
In-Reply-To: <20120613023816.GA24955@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wfg@linux.intel.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Hi Wu!

On Wed, 2012-06-13 at 10:38 +0800, wfg@linux.intel.com wrote:
> FYI, kernel build failed on
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next
> head:   414e7417f737b31a8e442214bcd6b2e9333761fd
> commit: e6baaa4223317089ac1f35d476a42976f01fe375 [5/15] target: add a pase_cdb method to the backend drivers
> config: i386-allmodconfig (attached as .config)
> 
> All related error/warning messages are:
> 
> ERROR: "target_emulate_set_target_port_groups" [drivers/target/target_core_pscsi.ko] undefined!
> ERROR: "target_emulate_report_target_port_groups" [drivers/target/target_core_pscsi.ko] undefined!
> 
> ---
> 0-DAY kernel build testing backend         Open Source Technology Centre
> Fengguang Wu <wfg@linux.intel.com>                     Intel Corporation

So the code in question ends up getting removed in the next patch:

     [6/15] pscsi: stop parsing most commands

but as you've noticed this series is not cleanly bisectable..

I'll go ahead and drop this problematic piece of code from patch #5 and
respin target-pending/for-next shortly.

Thank you!

--nab

