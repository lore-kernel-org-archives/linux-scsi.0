From: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>
Subject: Re: [PATCH] 2.4.X Avoid excessive recursion when setting device offline
Date: Mon, 29 Mar 2004 10:52:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <417630000.1080582749@aslan.btc.adaptec.com>
References: <387680000.1080580020@aslan.btc.adaptec.com> 	<1080581208.3570.10.camel@laptop.fenrus.com> <1080582471.2142.13.camel@mulgrave>
Reply-To: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:51937 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S263067AbUC2Rwc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2004 12:52:32 -0500
In-Reply-To: <1080582471.2142.13.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Arjan van de Ven <arjanv@redhat.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

> Yes, this patch is in 2.4.25 already.  I seem to recall that's why it
> was applied several years ago (to prevent recursion), but it's too long
> ago for me to remember (or even bitkeeper, since it's also in scsi_lib.c
> version 1.1).
> 
> Exactly which version of 2.4 is exhibiting this problem?

I was looking at RHEL3.  Sorry for the noise on the lists.
Arjan.  Please refer to bugzilla 119334.

--
Justin

