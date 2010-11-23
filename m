From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] target: simplify cmd to task mapping
Date: Tue, 23 Nov 2010 11:52:39 +0200
Message-ID: <4CEB8EE7.80106@panasas.com>
References: <20101117213857.GB26557@infradead.org> <4CE516F5.10400@panasas.com> <20101122210707.GA25898@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:52581 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0KWJwm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 04:52:42 -0500
In-Reply-To: <20101122210707.GA25898@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org

On 11/22/2010 11:07 PM, Christoph Hellwig wrote:
> On Thu, Nov 18, 2010 at 02:07:17PM +0200, Boaz Harrosh wrote:
>> If all these are mutual exclusive (if..elseif..else) can we not make
>> them an enum and switch() for costless-ness and clarity?
> 
> We could.  But IMHO we should simply get rid of all the special cases
> instead.  First remove the non-SG case, then fold the zero transfer
> length one in as a special zero-length SG and then check how many
> differences we have left between the data and control plane.
> 

ACK ^3

Boaz
