From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/3] 2.6.0 aacraid driver update
Date: Mon, 06 Oct 2003 18:24:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F81EB93.7060303@pobox.com>
References: <1065475266.17021.75.camel@markh1.pdx.osdl.net>	 <3F81E4D8.20904@pobox.com> <1065478184.17021.85.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:2203 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261943AbTJFWYd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2003 18:24:33 -0400
In-Reply-To: <1065478184.17021.85.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Mark Haverkamp wrote:
> I'll go back over everything and fix and make the casting more
> consistent, as well as check over the code for all you other comments.
> 
> Thanks for looking this over.


Thanks.  FWIW I tend to prefer to rely on C type promotion to avoid 
cluttering up the code with explicit casts.  This wanders a bit into 
developer's personal style preferences, but OTOH excessive casting has 
led to bugs in the past...

	Jeff



