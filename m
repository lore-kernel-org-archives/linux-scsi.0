From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/3] 2.6.0 aacraid driver update
Date: Tue, 07 Oct 2003 17:39:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F8332A3.70209@pobox.com>
References: <1065475266.17021.75.camel@markh1.pdx.osdl.net>	 <3F81E4D8.20904@pobox.com> <1065561492.29117.46.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:46246 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262913AbTJGVkA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2003 17:40:00 -0400
In-Reply-To: <1065561492.29117.46.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Mark Haverkamp wrote:
> If you just cast to unsigned long, as in the code below, there aren't any warnings, but
> the wrong type is being passed to the function.  So, I think that both the casts are
> needed.


There aren't any warnings that for case because C type promotion takes 
care of the rest

