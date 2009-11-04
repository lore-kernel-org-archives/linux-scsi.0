From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] qlogicpti: add missing parentheses
Date: Tue, 03 Nov 2009 16:19:06 -0800 (PST)
Message-ID: <20091103.161906.261075602.davem@davemloft.net>
References: <4AF0BF04.9030203@gmail.com>
	<1257292309.2454.54.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753856AbZKDASn@vger.kernel.org>
In-Reply-To: <1257292309.2454.54.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@suse.de
Cc: roel.kluin@gmail.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@suse.de>
Date: Tue, 03 Nov 2009 17:51:49 -0600

> On Wed, 2009-11-04 at 00:38 +0100, Roel Kluin wrote:
>> `+' has a higher precedence than `?' so the condition always
>> evaluates to true and this is preprocessed to `7*((ql) - 1)'
>> 
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> ---
>>  drivers/scsi/qlogicpti.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> This one must be right, I think.
> 
> It looks plausible ... but it will increase the mailbox segment length
> by 4 ... someone needs to verify that this increase will actually work
> and won't run off the end of the mailbox table.

It should be fine, good find Roel.

Acked-by: David S. Miller <davem@davemloft.net>
