From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: be2iscsi: Fixes
Date: Wed, 06 Oct 2010 16:55:43 -0500
Message-ID: <4CACF05F.2080803@cs.wisc.edu>
References: <20101006181406.GA25721@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56632 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab0JFVt2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Oct 2010 17:49:28 -0400
In-Reply-To: <20101006181406.GA25721@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 10/06/2010 01:14 PM, Jayamohan Kallickal wrote:
> Hi
>
>    	These set of patches have been made on
> latest scsi-rc-fixes-2.6 tree.
>
> 0001     Provide for time for FW to respond
> 0002     Fixing premature free of cid
> 0003     Handling for sge length == 64K. This was
> 	 submitted earlier but missed out
>
> 	Pl apply to scsi-rc-fixes-2.6 tree.
>

Patches look good.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
