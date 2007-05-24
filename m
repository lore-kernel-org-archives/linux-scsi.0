From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [patch 16/25] drivers/scsi/ips.c: remove kernel 2.4 code
Date: Thu, 24 May 2007 09:19:19 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1CA7@otce2k301.adaptec.com>
References: <200705232141.l4NLfkPu001210@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:46876 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbXEXNTV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 09:19:21 -0400
Content-class: urn:content-classes:message
In-reply-to: <200705232141.l4NLfkPu001210@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, bunk@stusta.de

Looks fine, totally inert. Inspected, could see no flaws.

Disclaimer: Resisting application to Adaptec version of the sources
since we still have to support legacy distributions, will keep
synchronized none-the-less.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: akpm@linux-foundation.org [mailto:akpm@linux-foundation.org] 
> Sent: Wednesday, May 23, 2007 5:42 PM
> To: James.Bottomley@steeleye.com
> Cc: linux-scsi@vger.kernel.org; akpm@linux-foundation.org; 
> bunk@stusta.de; AACRAID; IpsLinux
> Subject: [patch 16/25] drivers/scsi/ips.c: remove kernel 2.4 code
> 
> From: Adrian Bunk <bunk@stusta.de>
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> Cc: <aacraid@adaptec.com>
> Cc: <ipslinux@adaptec.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/ips.c |  145 +++++--------------------------------------
>  drivers/scsi/ips.h |   44 -------------
>  2 files changed, 20 insertions(+), 169 deletions(-)
