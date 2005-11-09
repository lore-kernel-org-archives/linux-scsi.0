From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [DOC PATCH]  T10/04-262r8
Date: Wed, 09 Nov 2005 10:56:44 -0500
Message-ID: <43721C3C.1010103@pobox.com>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF4A@WDSCEXBECL03.sc.wdc.com>	<4371BB82.3090208@gmx.de> <4371C557.80807@gmx.de> <4371F7C3.5080702@rtr.ca> <43720232.6090609@gmx.de> <4372172A.50003@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:50658 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751428AbVKIP4x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2005 10:56:53 -0500
In-Reply-To: <4372172A.50003@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: t.schorpp@gmx.de
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

thomas schorpp wrote:
> --- linux-git/include/scsi/scsi.h	2005-11-09 15:38:02.000000000 +0100
> +++ linux-2.6-dbg/include/scsi/scsi.h	2005-11-09 15:52:27.000000000 +0100
> @@ -116,7 +116,7 @@
>  /* values for service action in */
>  #define	SAI_READ_CAPACITY_16  0x10
>  
> -/* Values for T10/04-262r7 */
> +/* Values for T10/04-262r8 */
>  #define	ATA_16		      0x85	/* 16-byte pass-thru */
>  #define	ATA_12		      0xa1	/* 12-byte pass-thru */

This is a bit silly.  We should just remove the T10 doc reference, if 
people are going to be continually submitting patches to update this doc id.

	Jeff


