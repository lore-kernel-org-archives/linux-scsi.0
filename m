From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SCSI breaks 'make allyesconfig'
Date: 17 Nov 2004 10:21:22 -0600
Message-ID: <1100708492.2319.2.camel@mulgrave>
References: <419B5292.7080305@pobox.com>  <419B5AA2.7030801@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:42666 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262365AbUKQQVi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 11:21:38 -0500
In-Reply-To: <419B5AA2.7030801@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Wed, 2004-11-17 at 08:05, Jeff Garzik wrote:
> > drivers/scsi/osst.o(.bss+0x0): In function `exit_osst':
> > drivers/scsi/osst.c:195: multiple definition of `ST_partstat'
> > drivers/scsi/st.o(.bss+0x0):drivers/scsi/st.c:244: first defined here
> > make[2]: *** [drivers/scsi/built-in.o] Error 1
> > make[1]: *** [drivers/scsi] Error 2
> > make: *** [drivers] Error 2
> 
> 
>   ...and the attached patch fixes it.  'ST_partstat' is defined in 
> drivers/scsi/st.h, but never used.

Yes, this was reported and fixed yesterday.  The fix is already in the
SCSI BK repo:

http://linux-scsi.bkbits.net:8080/scsi-rc-fixes-2.6/cset@419a6d19FQrj1AswswaWWZLXreWppw

James


