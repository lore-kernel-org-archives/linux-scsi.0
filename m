From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2/2] RE: How to add/drop SCSI drives from within the
	drive r?
Date: Thu, 09 Dec 2004 20:24:41 -0600
Message-ID: <1102645481.3814.5.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E570230CAA0@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:9367 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261654AbULJCYx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 21:24:53 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230CAA0@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-12-09 at 20:21 -0500, Bagalkote, Sreenivas wrote:
> +i.	Introduced driver ioctl that returns scsi address for a given ld.
> +	
> +	"Why can't the existing sysfs interfaces be used to do this?"
> +		- Brian King (brking@us.ibm.com)
> +	
> +	"I've looked into solving this another way, but I cannot see how
> +	to get this driver-private mapping of logical drive number-> HCTL
> +	without putting code something like this into the driver."

OK now I look at the code, I have another suggestion.  Why not simply
publish the logical drive number as an extra file in the device sysfs
directory?  That way you can get your C:H:T:L, go to the end of the tree
and cat megaraid_sd (or whatever you want to call it).

James


