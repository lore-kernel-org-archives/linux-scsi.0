From: Willem Riede <wrlk@riede.org>
Subject: Re: [PATCH] Eliminate signals entirely from the mid-layer
Date: Sat, 11 Jan 2003 11:47:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030111164742.GV1378@linnie.riede.org>
References: <200301111544.h0BFiQD02270@localhost.localdomain>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200301111544.h0BFiQD02270@localhost.localdomain>; from James.Bottomley@steeleye.com on Sat, Jan 11, 2003 at 10:44:24 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On 2003.01.11 10:44 James Bottomley wrote:
> wrlk@riede.org said:
> > When I apply your patch, rmmod ide-scsi hangs. This is my log: 
> 
> Well, we all have these embarassing things we forget from time to time (like 
> remembering actually to tell the daemon to die...).  Can you try the attached 
> as an additional patch?
> 
Success!

With this change rmmod completes, the error handler exits when it is supposed to,
I can rmmod / modprobe ide-scsi repeatedly until I tire of it, and signals sent
deliberately to the error handler process with kill have no effect.

Regards, Willem Riede.
