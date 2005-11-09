From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [DOC PATCH]  T10/04-262r8
Date: Wed, 09 Nov 2005 11:22:43 -0500
Message-ID: <1131553363.3271.1.camel@mulgrave>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF4A@WDSCEXBECL03.sc.wdc.com>
	 <4371BB82.3090208@gmx.de> <4371C557.80807@gmx.de> <4371F7C3.5080702@rtr.ca>
	 <43720232.6090609@gmx.de> <4372172A.50003@gmx.de>
	 <43721C3C.1010103@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:3288 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751452AbVKIQW7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Nov 2005 11:22:59 -0500
In-Reply-To: <43721C3C.1010103@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: t.schorpp@gmx.de, Linux SCSI list <linux-scsi@vger.kernel.org>

> >  #define	ATA_16		      0x85	/* 16-byte pass-thru */
> >  #define	ATA_12		      0xa1	/* 12-byte pass-thru */
> 
> This is a bit silly.  We should just remove the T10 doc reference, if 
> people are going to be continually submitting patches to update this doc id.

Agreed ... especially since 04-262 is just a proposed update to SAT
which is what actually defines these command opcodes, so the comment
isn't even correct.

James


