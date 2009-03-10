From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] unnecessary SCSI module
Date: Tue, 10 Mar 2009 09:46:30 -0500
Message-ID: <1236696391.3316.6.camel@localhost.localdomain>
References: <49b60f4c@wupperonline.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755856AbZCJOqu@vger.kernel.org>
In-Reply-To: <49b60f4c@wupperonline.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Brueckl <ib@wupperonline.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-03-10 at 08:00 +0100, Ingo Brueckl wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> >> When configuring MODULES with the kernel to be able to load external
> >> drivers coming as modules, but not using anything as module in the kernel
> >> itself, one would expect to end up in a module-free kernel. Currently, you
> >> don't if you use SCSI. You'll get one unnecessary module.
> 
>  > This isn't right because SCSI_SCAN_ASYNC only sets the *default*
>  > behaviour of the kernel.  Even if it's n the user can still boot up with
>  > async scans by setting the kernel parameter.
> 
> Ok, understood. But has it to be a module then? Why not giving the choice
> between building it directly into the kernel or as a module?

If you read through the threads, that question is answered.

>  > It also keeps coming up regularly:
> 
> Well, then something doesn't seem to be ok, does it? ;-)

James
