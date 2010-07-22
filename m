From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 15/19] be2iscsi: iscsi boot changes for the kernel
Date: Thu, 22 Jul 2010 17:21:01 -0500
Message-ID: <4C48C44D.1060208@cs.wisc.edu>
References: <20100721225844.GA9750@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47639 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756971Ab0GVWSQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jul 2010 18:18:16 -0400
In-Reply-To: <20100721225844.GA9750@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, Konrad Rzeszutek <konrad@darnok.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

On 07/21/2010 05:58 PM, Jayamohan Kallickal wrote:
>    This patich kernel changes picked up from Konrad's tree
>
> Signed-off-by: Mike Christie<michaelc@cs.wisc.edu>
> Signed-off-by: Jayamohan Kallickal<jayamohank@serverengines.com>

The patchset looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>


The only issue might be this patch. James, this patch is in Konrad's 
tree for 2.6.36:
(it is actually 2 patches)
http://git.kernel.org/?p=linux/kernel/git/konrad/ibft-2.6.git;a=commit;h=ba4ee30c6c797de148dcc7254cf6d531aba71d9b
http://git.kernel.org/?p=linux/kernel/git/konrad/ibft-2.6.git;a=commit;h=b33a84a384776fb2593dac4d77c72050f9e181b0

So I am not sure who wants to send it upstream. I think as it is now, 
Konrad needs to send it because it depends on other patches in his tree.
