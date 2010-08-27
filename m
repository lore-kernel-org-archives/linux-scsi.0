From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: reverse the isr optimization changes
Date: Fri, 27 Aug 2010 16:49:44 -0500
Message-ID: <4C7832F8.3050001@linux.vnet.ibm.com>
References: <20100827175133.589741454@linux.vnet.ibm.com> <4C7831E3.6060305@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:60073 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab0H0Vtl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2010 17:49:41 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e38.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o7RLgFts027112
	for <linux-scsi@vger.kernel.org>; Fri, 27 Aug 2010 15:42:15 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o7RLnfnj203212
	for <linux-scsi@vger.kernel.org>; Fri, 27 Aug 2010 15:49:41 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o7RLrDEk028656
	for <linux-scsi@vger.kernel.org>; Fri, 27 Aug 2010 15:53:13 -0600
In-Reply-To: <4C7831E3.6060305@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

On 08/27/2010 04:45 PM, Wayne Boyer wrote:
> The isr optimization patch that was submitted a few months ago
> exposed problems with receiving and handling spurious HRRQ interrutps.
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=64ffdb762241c0a9c0c8fac7ea92aa0ba1529334
> 
> That patch is reverted with this one.  A new patch will be submitted
> once the issue is better understood and properly handled in the driver.

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


