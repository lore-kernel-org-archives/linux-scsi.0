From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/5] be2iscsi: Update to 10.4.74.0
Date: Fri, 08 Aug 2014 13:55:14 -0500
Message-ID: <53E51D12.5030002@cs.wisc.edu>
References: <1407474003-26220-1-git-send-email-jkallickal@emulex.com> <1407474003-26220-6-git-send-email-jkallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56964 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346AbaHHSzc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2014 14:55:32 -0400
In-Reply-To: <1407474003-26220-6-git-send-email-jkallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jay Kallickal <jayamohank@gmail.com>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

On 08/08/2014 12:00 AM, Jay Kallickal wrote:
> From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> 
>  This patchset updates be2iscsi driver to 10.4.74.0
> 
> These patches are based on for-next branch of scsi.git.
> 
> 0001 - Fix the sparse warning  
> 0002 - Update the copyright year
> 0003 - Fix updating the boot enteries in sysfs
> 0004 - Fix processing CQE before freeing connection resources
> 0005 - Bump the driver version
> 

Patches look ok to me. I am still behind on working on another fix for
4/5 which is more invasive, so that is ok with me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

