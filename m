From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] ibmvscsi driver
Date: 09 Feb 2004 16:55:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076363704.1804.48.camel@mulgrave>
References: <opr232htwdl6e53g@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:45733 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264477AbUBIVzI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2004 16:55:08 -0500
In-Reply-To: <opr232htwdl6e53g@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Dave Boutcher <sleddog@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-02-09 at 11:23, Dave Boutcher wrote:
> I would like to submit the following new driver for inclusion in the 2.6 
> kernel.  This is the first patch I'm sending outside of IBM, so I expect 
> there will be comments.

Could you elaborate more on why you actually want to use the SCSI
subsystem for this.

It looks like what you're proposing is a type of client/server device
pipe for which nbd may well be able to fill all your needs.

I'm not opposed to a simple SCSI tunnel driver, but knowing what you
need beyond what nbd can provide would help me understand why what
you're proposing is really necessary.

James


