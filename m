From: Madhu Iyengar <madhu.iyengar@qlogic.com>
Subject: RE: [PATCH 07/12] qla2xxx: Convert to host_lock less w/ interrupts
 disabled externally
Date: Mon, 3 Jan 2011 12:42:56 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87225A0F875@AVEXMB1.qlogic.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
	 <1292793727-31957-8-git-send-email-nab@linux-iscsi.org>
	 <20101219231114.GI1263@parisc-linux.org>
	 <1292837033.20840.39.camel@haakon2.linux-iscsi.org>
	 <5E4F49720D0BAD499EE1F01232234BA87225A0F1BC@AVEXMB1.qlogic.org>
	 <1293140968.4649.141.camel@haakon2.linux-iscsi.org>
	 <5E4F49720D0BAD499EE1F01232234BA87225A0F805@AVEXMB1.qlogic.org>
 <1294079823.4721.21.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:10753 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1ACUm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jan 2011 15:42:59 -0500
In-Reply-To: <1294079823.4721.21.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Madhu Iyengar <madhu.iyengar@qlogic.com>



-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de] 
Sent: Monday, January 03, 2011 10:37 AM
To: Madhu Iyengar
Cc: Nicholas A. Bellinger; linux-scsi; Ravi Anand; Andrew Vasquez; Giridhar Malavali
Subject: RE: [PATCH 07/12] qla2xxx: Convert to host_lock less w/ interrupts disabled externally

On Mon, 2011-01-03 at 10:25 -0800, Madhu Iyengar wrote:
> Thank you for your followup.  I think both of these patches look OK, so
> please feel free to add my:
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> 
> <MI> Thanks. Sure ... I'll add your signoff for the host_lock related patches.

> Actually, please don't do this unless the new qlogic patches are based
on the original patch (in which case, please preserve original
author)... the chain of signoffs describes how a patch gets from a set
of people into the tree.

Sure ... no problem (:-).

> James
>
> P.S. This quoting style is very hard for people to follow; can't you
> just use the standard '>' to quote prior emails?


