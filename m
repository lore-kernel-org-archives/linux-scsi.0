From: "Manish Kumar Bhojasia" <mbhojasi@cisco.com>
Subject: RE: [PATCH] Updated iscsi driver 4.0.1.2
Date: Tue, 30 Mar 2004 20:03:12 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <FFEFJMNKOMGHNFBIAHOCAEMEDGAA.mbhojasi@cisco.com>
References: <1080321647.2031.51.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ind-iport-1-sec.cisco.com ([64.104.129.9]:57643 "EHLO
	ind-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S263675AbUC3OdV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Mar 2004 09:33:21 -0500
In-Reply-To: <1080321647.2031.51.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "Linux-Iscsi-Devel@Lists. Sourceforge. Net" <linux-iscsi-devel@lists.sourceforge.net>

James,

We have taken care of propagating the iscsi-sfnet to various places
as suggested. Also, the compiler warning is fixed. We are releasing
4.0.1.3 driver with these changes now.

Thanks,
Manish

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> Sent: Friday, March 26, 2004 10:51 PM
> To: Manish Kumar Bhojasia
> Cc: SCSI Mailing List; Linux-Iscsi-Devel@Lists. Sourceforge. Net
> Subject: Re: [PATCH] Updated iscsi driver 4.0.1.2
> 
> 
> On Fri, 2004-03-26 at 11:05, Manish Kumar Bhojasia wrote:
> > Please review and let us know your comments.
> 
> Thanks for moving this to iscsi-sfnet.  I think the config option and
> the module name need to follow suit (I also note that the printk id
> strings still say Cisco iSCSI driver).
> 
> I still get a compile failure:
> 
>   CC [M]  drivers/scsi/iscsi-sfnet/iscsi-debug-attr.o
> cc1: warnings being treated as errors
> drivers/scsi/iscsi-sfnet/iscsi-debug-attr.c: In function
> `iscsi_target_printcmnd':
> drivers/scsi/iscsi-sfnet/iscsi-debug-attr.c:977: warning: int format,
> different type arg (arg 4)
> make[3]: *** [drivers/scsi/iscsi-sfnet/iscsi-debug-attr.o] Error 1
> make[2]: *** [drivers/scsi/iscsi-sfnet] Error 2
> make[1]: *** [drivers/scsi] Error 2
> make: *** [drivers] Error 2
> 
> This looks to be because of -Werror rather than anything serious.
> 
> James
> 
> 
> 
