From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] libata new EH document
Date: Thu, 01 Sep 2005 17:55:18 -0400
Message-ID: <1125611718.4946.20.camel@mulgrave>
References: <20050901043850.15186.qmail@web51611.mail.yahoo.com>
	 <43169520.6040008@gmail.com>  <20050901055421.GA23496@havoc.gtf.org>
	 <1125581097.4834.5.camel@mulgrave>  <4317755C.5080700@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:53948 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030420AbVIAV4c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Sep 2005 17:56:32 -0400
In-Reply-To: <4317755C.5080700@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, ltuikov@yahoo.com, Albert Lee <albertcc@tw.ibm.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Doug Maxey <dwm@maxeymade.com>

On Thu, 2005-09-01 at 17:40 -0400, Luben Tuikov wrote:
> > The current SCSI autosense in drivers doesn't require this because we
> > reuse the existing command that got the contingent allegiance condition.
> 
> Care to elaborate what "contingent allegiance condition" is,
> how SCSI Core got it, how SCSI Core is using it, and how SCSI Core set
> it up with the LU?

Well, not really, since it's basic SCSI and the explanation's pretty
long.  However, the standards have several pages about it.  For your
reading pleasure, I suggest SAM-2 section 5.9.1 Contingent allegiance
(CA) and auto contingent allegiance (ACA)

James


