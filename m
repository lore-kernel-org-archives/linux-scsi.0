From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] Eliminate signals entirely from the mid-layer
Date: Sat, 11 Jan 2003 08:33:30 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030111163330.GA1878@beaverton.ibm.com>
References: <20030111142311.GQ1378@linnie.riede.org> <200301111544.h0BFiQD02270@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200301111544.h0BFiQD02270@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: wrlk@riede.org, linux-scsi@vger.kernel.org

James Bottomley [James.Bottomley@steeleye.com] wrote:
> wrlk@riede.org said:
> > When I apply your patch, rmmod ide-scsi hangs. This is my log: 
> 
> Well, we all have these embarassing things we forget from time to time (like 
> remembering actually to tell the daemon to die...).  Can you try the attached 
> as an additional patch?

I applied your patch plus this last change to my 2.5.55 view and the error
handler is exiting on rmmod of scsi_debug.

I did some drive pulls and the error handler woke up and returned to
sleep. (The errors where not cleared, but that is not related to your
patch)

-andmike
--
Michael Anderson
andmike@us.ibm.com

