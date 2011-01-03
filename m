From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH 07/12] qla2xxx: Convert to host_lock less w/ interrupts
 disabled externally
Date: Mon, 03 Jan 2011 12:37:03 -0600
Message-ID: <1294079823.4721.21.camel@mulgrave.site>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
	 <1292793727-31957-8-git-send-email-nab@linux-iscsi.org>
	 <20101219231114.GI1263@parisc-linux.org>
	 <1292837033.20840.39.camel@haakon2.linux-iscsi.org>
	 <5E4F49720D0BAD499EE1F01232234BA87225A0F1BC@AVEXMB1.qlogic.org>
	 <1293140968.4649.141.camel@haakon2.linux-iscsi.org>
	 <5E4F49720D0BAD499EE1F01232234BA87225A0F805@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab1ACShK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jan 2011 13:37:10 -0500
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA87225A0F805@AVEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Madhu Iyengar <madhu.iyengar@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>

On Mon, 2011-01-03 at 10:25 -0800, Madhu Iyengar wrote:
> Thank you for your followup.  I think both of these patches look OK, so
> please feel free to add my:
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> 
> <MI> Thanks. Sure ... I'll add your signoff for the host_lock related patches.

Actually, please don't do this unless the new qlogic patches are based
on the original patch (in which case, please preserve original
author)... the chain of signoffs describes how a patch gets from a set
of people into the tree.

James

P.S. This quoting style is very hard for people to follow; can't you
just use the standard '>' to quote prior emails?

