From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 07/13] target: Inline struct se_tmr_req into se_cmd
Date: Mon, 26 Mar 2012 09:08:44 -0700
Message-ID: <4F70948C.9030505@redhat.com>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com> <1327009163-10177-8-git-send-email-agrover@redhat.com> <20120120161209.GA22481@infradead.org> <4F19A80B.6000902@redhat.com> <20120326092559.GB27806@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932809Ab2CZQNv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Mar 2012 12:13:51 -0400
In-Reply-To: <20120326092559.GB27806@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, kiran.patil@intel.com

On 03/26/2012 02:25 AM, Christoph Hellwig wrote:
> On Fri, Jan 20, 2012 at 09:44:43AM -0800, Andy Grover wrote:
>> On 01/20/2012 08:12 AM, Christoph Hellwig wrote:
>>> On Thu, Jan 19, 2012 at 01:39:17PM -0800, Andy Grover wrote:
>>>> This saves all fabrics from calling core_tmr_alloc_req() and
>>>> having to check the result. The downside is se_cmd gets bigger for all
>>>> requests, but hopefully later patches will reduce it.
>>>
>>> Without patches to void the overhead it's not acceptable. Fortunately
>>> it should be doable fairly simply by using an union for command vs
>>> TMR fields.
>>
>> This was my thought too. We should be able to move cmd variables into a
>> union w/tmr struct very soon, with a low risk of introducing bugs.
> 
> Any plans on going back to this?

I'm working on a cleanup patch series that keeps getting bigger, and
this will either end up in it, or I'll get to it right afterwards.

-- Andy
