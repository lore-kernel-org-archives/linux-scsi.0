From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: aic94xx tree up on www.kernel.org
Date: Mon, 6 Mar 2006 14:44:58 -0800
Message-ID: <20060306224458.GA7797@us.ibm.com>
References: <1141669543.3167.25.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:47272 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1752440AbWCFWvB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Mar 2006 17:51:01 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k26Mp09v006021
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 17:51:00 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k26MrmSr165194
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 15:53:48 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k26MoxcL005511
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 15:51:00 -0700
Content-Disposition: inline
In-Reply-To: <1141669543.3167.25.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> I've put it at
> 
> http://www.kernel.org/git/?p=linux/kernel/git/jejb/aic94xx-sas-2.6.git;a=summary
> 
> With the rolled up patches and change logs at:
> 
> http://www.kernel.org/pub/linux/kernel/people/jejb/

I am hitting an error trying to compile the tree due to the define for
struct sas_end_device missing. I saw usage added in "Further updates:". I
guess I can reverse these changes to get it to compile or do you have the
define and it just did not get added?

-andmike
--
Michael Anderson
andmike@us.ibm.com
