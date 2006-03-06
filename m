From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic94xx tree up on www.kernel.org
Date: Mon, 06 Mar 2006 17:23:51 -0600
Message-ID: <1141687431.3430.0.camel@mulgrave.il.steeleye.com>
References: <1141669543.3167.25.camel@mulgrave.il.steeleye.com>
	 <20060306224458.GA7797@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:9171 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751957AbWCFXXy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Mar 2006 18:23:54 -0500
In-Reply-To: <20060306224458.GA7797@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

On Mon, 2006-03-06 at 14:44 -0800, Mike Anderson wrote:
> I am hitting an error trying to compile the tree due to the define for
> struct sas_end_device missing. I saw usage added in "Further updates:". I
> guess I can reverse these changes to get it to compile or do you have the
> define and it just did not get added?

You need scsi-misc-2.6 as well to get the latest sas transport class
updates.

James


