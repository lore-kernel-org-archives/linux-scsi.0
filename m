From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v1.0 12/16] arcmsr: revise alloction of second
 dma_coherent_handle for type B adapter
Date: Fri, 2 May 2014 11:57:13 +0300
Message-ID: <20140502085713.GF4963@mwanda>
References: <1398857429.6930.51.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47484 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaEBI53 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2014 04:57:29 -0400
Content-Disposition: inline
In-Reply-To: <1398857429.6930.51.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ching <ching2048@areca.com.tw>
Cc: jbottomley@parallels.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Wed, Apr 30, 2014 at 07:30:29PM +0800, ching wrote:
> From: Ching<ching2048@areca.com.tw>
> 
> Revise allocation of second dma_coherent_handle for type_B adapter.
> 

Is this a bugfix?  I think it is.  Do you know what the user visible
effects are?

regards,
dan carpenter

