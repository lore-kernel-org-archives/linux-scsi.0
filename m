From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 0/17] Clear up bidi command confusion
Date: Thu, 29 Jan 2015 14:20:33 +0100
Message-ID: <54CA33A1.2020104@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
 <20150123131249.GA8045@infradead.org> <54C60FCC.4060601@sandisk.com>
 <54CA30A8.5020101@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0072.outbound.protection.outlook.com ([157.56.111.72]:51168
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755863AbbA2NUl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2015 08:20:41 -0500
In-Reply-To: <54CA30A8.5020101@plexistor.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/29/15 14:07, Boaz Harrosh wrote:
> On 01/26/2015 11:58 AM, Bart Van Assche wrote:
> 
>> Hello Christoph,
>>
>> This makes sense to me. I will rework this patch series as you proposed.
> 
> Do you have a bidi setup to test against?
> 
> Sending xor command to scsi_dbg is only half the test for me because, yes
> there are two buffers, but they are of same size so bugs might be masked.
> (From experience)

Hello Boaz,

If anyone would like to submit a scsi_debug patch that adds support to
that kernel driver for a bidi command for which the input and output
buffers have different sizes I think that would be helpful.

Bart.

