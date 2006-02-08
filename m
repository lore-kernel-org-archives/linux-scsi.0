From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Regarding ordered-tag support.
Date: Wed, 08 Feb 2006 13:04:15 -0500
Message-ID: <43EA329F.2000906@pobox.com>
References: <43E99248.7090505@gmail.com>	 <1139413766.3003.19.camel@mulgrave.il.steeleye.com>	 <43EA17E6.4000800@gmail.com> <43EA1B75.40008@emulex.com>	 <43EA2313.9030506@gmail.com>	 <1139418451.3003.37.camel@mulgrave.il.steeleye.com>	 <43EA27E4.9080105@gmail.com> <1139419637.3003.43.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:2195 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030322AbWBHSEZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2006 13:04:25 -0500
In-Reply-To: <1139419637.3003.43.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Tejun <htejun@gmail.com>, James.Smart@Emulex.Com, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> I suppose I'm a broken record, but I really think linked tasks are the
> better way to enforce the required ordering guarantees for SCSI TCQ.
> The problem being that this would present a slightly different API at
> the block level (you have individual writes that are now ordered, not
> wholesale barriers).


I strongly agree, since fundamentally, linked tasks is what is really 
going on.

	Jeff


