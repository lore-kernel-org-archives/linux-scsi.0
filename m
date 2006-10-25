From: Ismail Donmez <ismail@pardus.org.tr>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.19-rc3
Date: Wed, 25 Oct 2006 23:04:35 +0300
Message-ID: <200610252304.36098.ismail@pardus.org.tr>
References: <1161792760.3816.6.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.uludag.org.tr ([193.140.100.220]:43231 "EHLO uludag.org.tr")
	by vger.kernel.org with ESMTP id S964832AbWJYUEs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Oct 2006 16:04:48 -0400
In-Reply-To: <1161792760.3816.6.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Andrew,
25 Eki 2006 =C3=87ar 19:12 tarihinde, James Bottomley =C5=9Funlar=C4=B1=
 yazm=C4=B1=C5=9Ft=C4=B1:=20
[...]
> Tomonori FUJITA:
>   o replace u8 and u32 with __u8 and __u32 in scsi.h for user space

This patch obsoletes my =20
scsi-scsih-protect-scsi_to_u32-function-by-ifdef-__kernel__.patch . It =
would=20
be nicer if I got CC'd oh well.

Regards,
ismail
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
