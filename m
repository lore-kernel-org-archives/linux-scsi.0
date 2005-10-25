From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/2] libata: Remove dependence on host_set->dev for SAS
Date: Tue, 25 Oct 2005 15:43:03 -0400
Message-ID: <435E8AC7.1080407@pobox.com>
References: <4341A91A.3020000@us.ibm.com> <434251E0.9060000@pobox.com>	 <58cb370e0510040322q1cb7a13bjfc6c7875140d20a9@mail.gmail.com> <58cb370e0510041356h780e7a5aifda0c232f677471e@mail.gmail.com> <43443E99.4090008@pobox.com> <435D5D83.1060201@us.ibm.com> <435D5DE5.7010306@us.ibm.com> <435E7105.4010105@pobox.com> <435E87E8.9010506@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:39122 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932326AbVJYTnL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Oct 2005 15:43:11 -0400
In-Reply-To: <435E87E8.9010506@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Brian King wrote:
> Or, we just live with the duplication...

That may be the best practical solution.

I wonder, additionally, if we need to be getting a reference each time 
we store the pointer.  Traditionally the struct device object lifetime 
has always been entirely within the bus device lifetime, but with this 
new work that may need rethinking.

	Jeff


