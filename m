From: Michael Heinz <mheinz@infiniconsys.com>
Subject: Re: Possible bug handling bad I/Os?
Date: Thu, 29 Aug 2002 13:11:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B993CDEB.2C0F%mheinz@infiniconsys.com>
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

> 
> [ You didn't specify your kernel version, so the below comment is for 2.4
> kernels, on 2.5 kernels all drivers are treated as new eh drivers ]
> Does your driver use the new eh code?  If not, then this is your problem.
> Non new eh code based drivers are not allowed to fail a queue_command
> call, and the return value isn't checked.
> 

A little more detail - if the caller wasn't checking my return code at all,
I would expect the SCSI layer to send me an abort when the command times out
- but it doesn't, it goes inert.


-- 
Michael Heinz <mheinz@infiniconsys.com>
Staff Software Engineer
InfiniCon Systems, Inc.

