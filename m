From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch] libsas: dereferencing variable before check
Date: Thu, 13 May 2010 16:37:50 +0200
Message-ID: <4BEC0EBE.7000404@kernel.org>
References: <20100512225629.GB5695@bicker>	 <23e0bf65-8758-45b3-b0a8-1df97db07d9a@email.android.com> <1273761114.4353.122.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1273761114.4353.122.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Dan Carpenter <error27@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On 05/13/2010 04:31 PM, James Bottomley wrote:
>> Ooh.. right.
>>
>> Asked-by: Tejun Heo <tj@kernel.org>

That was my first mail from android and of course I typed Asked
instead of Acked.  :-)

> Well, oops, yes.  Two patches to fix one bug is a bit overboard, I
> think, plus some code rearrangement to fix the locality of the problem
> and ensure it doesn't happen again might be useful.  What about this.

Yeap, as long as the silly bug is fixed.

Thank you.

-- 
tejun
