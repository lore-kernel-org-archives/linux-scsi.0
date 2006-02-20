From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] aic94xx: driver assertion in non-x86 BIOS env
Date: Mon, 20 Feb 2006 06:11:59 -0500
Message-ID: <43F9A3FF.308@pobox.com>
References: <20060217023613.GA30583@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:27347 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932447AbWBTLMD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2006 06:12:03 -0500
In-Reply-To: <20060217023613.GA30583@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Tarte@us.ibm.com, Robert <Robert_Tarte@adaptec.com>, Jeff Garzik <jgarzik@redhat.com>

Mike Anderson wrote:
> This patch addresses the issue of the aic94xx driver not working on
> non-x86 or on systems where the card bios had been disabled.
> http://bugzilla.kernel.org/show_bug.cgi?id=6042
> 
> Rob Tarte, Jeff Ding, and I coordinated on the fix for the OCM issue.
> 
> The patch has been run on a Powermac G5, a PPC64, and IA64 based system.
> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> 
>  This purpose of this patch is to allow the aic94xx driver to load and
>  function on archs that do not allow the cards bios to run. This patch
>  contains a forward port of code changes made to the adp94xx driver
>  that inits the ocm if the bios did not. The patch also provides default
>  parameters for flash values if the flash data cannot be read.
> 
>  Signed-off-by: Mike Anderson <andmike@us.ibm.com>

applied to sas-2.6.git#upstream (and #ALL, and thus to Andrew's -mm)

	Jeff



