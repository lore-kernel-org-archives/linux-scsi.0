From: Michael Heinz <mheinz@infiniconsys.com>
Subject: Re: Possible bug handling bad I/Os?
Date: Thu, 29 Aug 2002 12:58:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B993CAF2.2C0C%mheinz@infiniconsys.com>
References: <20020829124142.D31625@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020829124142.D31625@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 8/29/02 12:41 PM, "Doug Ledford" <dledford@redhat.com> wrote:

> On Thu, Aug 29, 2002 at 09:34:28AM -0400, Michael Heinz wrote:
>> The last thing to happen seemed to be that my driver would get a call to
>> queue_command while I knew the connection was down. Since I knew the
>> connection was down I would simply immediately return an error and do
>> nothing else.
> 
> [ You didn't specify your kernel version, so the below comment is for 2.4
> kernels, on 2.5 kernels all drivers are treated as new eh drivers ]
> Does your driver use the new eh code?  If not, then this is your problem.
> Non new eh code based drivers are not allowed to fail a queue_command
> call, and the return value isn't checked.

I'm using the new model eh stuff in 2.4.

-- 
Michael Heinz <mheinz@infiniconsys.com>
Staff Software Engineer
InfiniCon Systems, Inc.

