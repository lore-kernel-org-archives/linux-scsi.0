From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Mon, 19 Jan 2015 10:36:13 +0100
Message-ID: <54BCD00D.4080603@sandisk.com>
References: <54B63F74.2040702@sandisk.com>
 <20150115090829.GA14154@infradead.org> <54B7E70C.8020304@sandisk.com>
 <20150119092153.GA8666@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0058.outbound.protection.outlook.com ([157.56.111.58]:45472
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751501AbbASJgW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2015 04:36:22 -0500
In-Reply-To: <20150119092153.GA8666@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On 01/19/15 10:22, Christoph Hellwig wrote:
> On Thu, Jan 15, 2015 at 05:13:00PM +0100, Bart Van Assche wrote:
>> My goal is to realize this proposal without adding hooks for out-of-tree
>> code in the upstream kernel. What I had in mind is to raise the
>> abstraction level of the API between LIO core and target drivers a
>> little bit (e.g. by using accessor functions where necessary instead of
>> accessing structure members directly)
> 
> That's very much a hook, althiugh a week one.
> 
> Either way I don't think bringing up a very much political topic
> without even any code to discuss isn't a very valueable use of our time
> slots.

A possible approach is that I start implementing a unified SRP target
driver and post that driver together with the necessary LIO and SCST
core changes before the LSF/MM starts. That could be a helpful starting
point for further discussions.

Bart.
