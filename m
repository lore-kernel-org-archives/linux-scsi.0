From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue reached
Date: Mon, 3 Mar 2003 15:41:19 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030303154119.A31562@beaverton.ibm.com>
References: <20030228111924.A32018@beaverton.ibm.com> <3E627037.9060809@splentec.com> <20030303125254.A30662@beaverton.ibm.com> <3E63D9FB.1010602@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E63D9FB.1010602@splentec.com>; from luben@splentec.com on Mon, Mar 03, 2003 at 05:40:59PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

Luben -

On Mon, Mar 03, 2003 at 05:40:59PM -0500, Luben Tuikov wrote:

> Ah, yes, sadly I see the [political] compromize -- I promize to
> straighten this out with the source right after I finish this email.
> In due time you're allowed free thinking. :-)

Well they are just names, the important issue is that we understand how
the code uses them.

> But isn't it a queue? Furhermore isn't it a queue of _deferred_
> *by SCSI Core* commands, because the host command limit were hit?
> 
> Then wouldn't it *make sense* to call it ``deferred_q'' or
> ``deferred_cmd_q''?
> 
> Doesn't this just *make sense*?

It is a struct list_head, you can call it a queue but it is coded as a
list_head. Adding _q or _queue does not change anything, or make the code
easier to understand.

There is not much difference between "pending" and "deferred" (damn I
actually had to go look those up in a dictionary), though SAM-3 references
pending, I don't see any SAM references to deferred.

The name can always be modified via future patches.

-- Patrick Mansfield
