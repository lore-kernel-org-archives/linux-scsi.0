From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH]: mpt2sas crashes on shutdown
Date: Tue, 27 Dec 2011 13:24:19 -0500
Message-ID: <4EFA0D53.9000605@interlog.com>
References: <20111226.145920.1088076837634135764.davem@davemloft.net> <4565AEA676113A449269C2F3A549520FAC5B1C55@cosmail03.lsi.com> <20111227.130550.165386147383560860.davem@davemloft.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38419 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab1L0SY3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Dec 2011 13:24:29 -0500
In-Reply-To: <20111227.130550.165386147383560860.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: Eric.Moore@lsi.com, stable@vger.kernel.org, linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com

On 11-12-27 01:05 PM, David Miller wrote:
> From: "Moore, Eric"<Eric.Moore@lsi.com>
> Date: Tue, 27 Dec 2011 10:09:28 -0700
>
>> David - The backup and restoring of the MSIX vector capabilities registers across diagnostic reset was only needed for our pre-production cards (A0 parts). It was a workaround for some hardware errata.  This is not needed anymore as there was a fix addressed before those controllers when to production, so I finally removed this workaround in the driver during phase 10 in the LSI in-house drivers, which was about 10 months ago.  Attached is my commit for the in-house drivers.  You should be able to remove the save_msix_table and restore_msix_table routines as I did.
>
> I don't care how it is fixed, I only care that a fix makes it's way into -stable.
>
> You LSI guys seem to ignore the -stable series and submit _ZERO_ bug
> fixes for your driver there, leaving it to people like me suffering
> from the bugs to submit the fixes for you.
>
> Therefore it is kind of out of place for you to suggest a specific way you want
> the bug fixed, because obviously you guys don't care about backporting bug
> fixes to -stable in the first place.
>
> With that in mind, why not leave the decision to people who actually
> care, have actually tested the fix, and bothered to submit it to -stable?

... and goodwill to all.

