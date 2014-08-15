From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] scsi: Fix qemu boot hang problem
Date: Fri, 15 Aug 2014 12:26:50 -0700
Message-ID: <53EE5EFA.30102@roeck-us.net>
References: <1407675265-29192-1-git-send-email-linux@roeck-us.net> <53EE4FDE.2070904@roeck-us.net> <53EE52AE.4050006@kernel.dk> <20140815192253.GA22752@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140815192253.GA22752@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Webb Scales <webbnh@hp.com>
List-Id: linux-scsi@vger.kernel.org

On 08/15/2014 12:22 PM, Christoph Hellwig wrote:
> On Fri, Aug 15, 2014 at 12:34:22PM -0600, Jens Axboe wrote:
>> On 2014-08-15 12:22, Guenter Roeck wrote:
>>> ping ... the problem fixed by this patch still affects the upstream kernel
>>> (v3.16-11383-gc9d2642) as well as -next (20140815).
>>
>> James, could you upstream this one in time for -rc1?
>
> It's in the core-for-3.17 updates I sent to James yesterday, just needs to
> be forwarded..
>

Great, thanks a lot!

Guenter
