From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Updated iscsi driver 4.0.1.2
Date: 26 Mar 2004 12:20:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080321647.2031.51.camel@mulgrave>
References: <FFEFJMNKOMGHNFBIAHOCOEHPDGAA.mbhojasi@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:39862 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263500AbUCZRVX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Mar 2004 12:21:23 -0500
In-Reply-To: <FFEFJMNKOMGHNFBIAHOCOEHPDGAA.mbhojasi@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Manish Kumar Bhojasia <mbhojasi@cisco.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "Linux-Iscsi-Devel@Lists.  Sourceforge. Net" <linux-iscsi-devel@lists.sourceforge.net>

On Fri, 2004-03-26 at 11:05, Manish Kumar Bhojasia wrote:
> Please review and let us know your comments.

Thanks for moving this to iscsi-sfnet.  I think the config option and
the module name need to follow suit (I also note that the printk id
strings still say Cisco iSCSI driver).

I still get a compile failure:

  CC [M]  drivers/scsi/iscsi-sfnet/iscsi-debug-attr.o
cc1: warnings being treated as errors
drivers/scsi/iscsi-sfnet/iscsi-debug-attr.c: In function
`iscsi_target_printcmnd':
drivers/scsi/iscsi-sfnet/iscsi-debug-attr.c:977: warning: int format,
different type arg (arg 4)
make[3]: *** [drivers/scsi/iscsi-sfnet/iscsi-debug-attr.o] Error 1
make[2]: *** [drivers/scsi/iscsi-sfnet] Error 2
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

This looks to be because of -Werror rather than anything serious.

James


