From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] scsi: handle special return codes for ABORTED COMMAND
Date: Tue, 30 Jan 2018 01:01:39 +0100
Message-ID: <1517270499.12805.33.camel@suse.com>
References: <20180129233013.23474-1-mwilck@suse.com>
         <1517269153.2687.61.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:49772 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752267AbeA3ACC (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 29 Jan 2018 19:02:02 -0500
In-Reply-To: <1517269153.2687.61.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2018-01-29 at 23:39 +0000, Bart Van Assche wrote:
> On Tue, 2018-01-30 at 00:30 +0100, Martin Wilck wrote:
> > +	static struct aborted_cmd_blist blist[] = {
> 
> Please consider to declare this array const.

That doesn't work because I want to store the "warned" flag in it. And
I think it'd be good to print one message per asc/ascq combination,
rather than just having a single static "warned" variable.

> > +	for (i = 0; i < sizeof(blist)/sizeof(struct
> > aborted_cmd_blist); i++) {
> 
> Have you considered to use ARRAY_SIZE()?

No. Thanks for the hint. I'll re-post.

Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
