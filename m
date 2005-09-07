From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] SCSI EH document
Date: Wed, 07 Sep 2005 09:00:30 -0500
Message-ID: <1126101630.4823.6.camel@mulgrave>
References: <20050826035326.GA13392@htj.dyndns.org>
	 <431E9F14.7070703@pobox.com>  <431ECD91.80407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:53898 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751211AbVIGOAy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 10:00:54 -0400
In-Reply-To: <431ECD91.80407@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, luben_tuikov@adaptec.com, albertcc@tw.ibm.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-09-07 at 20:22 +0900, Tejun Heo wrote:
>   If James agrees, I'll reformat it to DocBook and submit the patch. 
> James, what do you think?

Certainly ... just submit it as a patch and I'll put it in.

As far as docbook goes, that's fine ... it's just that docbook has to be
built and it's supposed to derive its API from the actual files its
describing (although you get to do the sections) ... not that all
docbook files do this, of course.

James


