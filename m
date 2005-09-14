From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.13 5/14] sas-class: sas_discover.c Discover process
 (end devices)
Date: Wed, 14 Sep 2005 16:20:48 -0400
Message-ID: <43288620.2070302@adaptec.com>
References: <20050910024454.20602.qmail@web51613.mail.yahoo.com>	 <1126368081.4813.46.camel@mulgrave> <4325997D.3050103@adaptec.com>	 <20050912162739.GA11455@us.ibm.com> <4326964B.9010503@torque.net>	 <20050913224215.GB1308@us.ibm.com> <1126723680.4588.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:42657 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932560AbVINUUz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 16:20:55 -0400
In-Reply-To: <1126723680.4588.9.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Douglas Gilbert <dougg@torque.net>, ltuikov@yahoo.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 09/14/05 14:47, James Bottomley wrote:
> On Tue, 2005-09-13 at 15:42 -0700, Patrick Mansfield wrote:
> 
>>So adding a W_LUN at this point does not add any value ... maybe it looks
>>nice in the spec and in someones firmware, but it does not add anything
>>that I can see.
> 
> 
> Well I agree with the analysis, but even given that, we have a linux
> implementation problem: We have to get an inquiry response first before
> we begin a report luns scan.  An array implementing a W_LUN is entitled
> not respond on LUN 0 to INQUIRY with an error, which would mean we don't
> see it.
> 
> Therefore, I think our strategy has to be when the current probe fails
> because of no LUN 0 try a report luns scan on the W_LUN anyway as long
> as the transport indicates it is capable of supporting it (i.e. as long
> as it has max_luns set at 0xffff or higher).

Alternatively, you can see how this is all properly implemented
in the SAS Layer which I posted last week.

All indications point to the fact that you had indeed taken
a look at the code.

	Luben

