From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: move entirely over to correct transport class
	formulation
Date: Tue, 28 Mar 2006 09:06:26 -0600
Message-ID: <1143558386.3353.6.camel@mulgrave.il.steeleye.com>
References: <1143499534.3334.33.camel@mulgrave.il.steeleye.com>
	 <20060328053902.GA15968@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:17643 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750780AbWC1PGs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 10:06:48 -0500
In-Reply-To: <20060328053902.GA15968@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2006-03-27 at 21:39 -0800, Mike Anderson wrote:
> I did a git pull from the aic tree and scsi-misc, and applied your patch.
> Was scsi_sas_internal.h suppose to be in this patch?

No .. that has to go through scsi-misc-2.6, which I'm in the process of
setting up ...

James


