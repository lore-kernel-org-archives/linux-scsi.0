From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch 3/3] aic7...: Fix bad __exit reference
Date: Sat, 1 May 2004 21:04:25 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040501110425.GA29776@gondor.apana.org.au>
References: <200404270501.i3R51h207741@mail.osdl.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from arnor.apana.org.au ([203.14.152.115]:3084 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S261248AbUEALFA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 May 2004 07:05:00 -0400
Content-Disposition: inline
In-Reply-To: <200404270501.i3R51h207741@mail.osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, gibbs@scsiguy.com, linux-scsi@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 26, 2004 at 10:01:28PM -0700, akpm@osdl.org wrote:
> 
> From: Herbert Xu <herbert@gondor.apana.org.au>
> 
> >
> > Error: ./drivers/scsi/aic7xxx/aic7xxx_osm.o .init.text refers to
> > 0000000000000040 ELF_LITERAL       .exit.text
> > Error: ./drivers/scsi/aic7xxx/aic7xxx_osm.o .init.text refers to
> > 0000000000000044 HINT              .exit.text
> > Error: ./drivers/scsi/aic7xxx/aic7xxx_osm.o .eh_frame refers to
> > 0000000000000941 SREL32            .exit.text
> 
> That was my fault.  This patch should fix it.

Here is a follow-up patch to delete the now-unused exit prototype.

Thanks,
-- 
Debian GNU/Linux 3.0 is out! ( http://www.debian.org/ )
Email:  Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=p

Index: drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
RCS file: /home/gondolin/herbert/src/CVS/debian/kernel-source-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c,v
retrieving revision 1.6
diff -u -r1.6 aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c	23 Apr 2004 10:19:47 -0000	1.6
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c	1 May 2004 11:02:40 -0000
@@ -5083,8 +5083,6 @@
 	}
 }
 
-static void __exit ahc_linux_exit(void);
-
 static int __init
 ahc_linux_init(void)
 {

--ew6BAiZeqk4r7MaW--
