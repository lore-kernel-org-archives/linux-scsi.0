From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Date: Thu, 30 Jul 2009 12:05:32 +0300
Message-ID: <4A71625C.8060707@panasas.com>
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site> <4A705831.3010002@panasas.com> <20090729205626.GA3592@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:23102
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751037AbZG3JFg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2009 05:05:36 -0400
In-Reply-To: <20090729205626.GA3592@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 07/29/2009 11:56 PM, Michael S. Tsirkin wrote:
> On Wed, Jul 29, 2009 at 05:09:53PM +0300, Boaz Harrosh wrote:
>> TODO:
>> * Fix up Kernel headers by complying to check_headers
> 
> This is accomplished by applying the following on top
> of my previous patch:
> 

This is not enough. The same should be done to the other 3 
include/scsi headers I mentioned and export them.

<snip>

Boaz
