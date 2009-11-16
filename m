From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Mon, 16 Nov 2009 09:51:08 -0600
Message-ID: <1258386668.2517.7.camel@mulgrave.site>
References: <4F2B1A2459C7AD4D96A23CE911C352CB1E9150B996@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40312 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbZKPPvL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Nov 2009 10:51:11 -0500
In-Reply-To: <4F2B1A2459C7AD4D96A23CE911C352CB1E9150B996@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Penchala Narasimha Reddy Chilakala, ERS-HCLTech" <narasimhareddyc@hcl.in>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, James Bottomley <jejb@kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

On Mon, 2009-11-16 at 08:55 +0530, Penchala Narasimha Reddy Chilakala,
ERS-HCLTech wrote:
> Hi James,
> 
> Thanks a lot for your nice review, feedback and support so far. I hope
> that we have sorted out all the issues raised by you except the racy
> issue.

Yes ... I think the race problem isn't particularly relevant to the
bugs, so send me a patch without the attempted ioctl fib counting and it
can go into -rc ... you can work on the fib counting later for
scsi-misc.

James


