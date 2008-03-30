From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [patch 08/17] scsi: replace remaining __FUNCTION__ occurrences
Date: Sun, 30 Mar 2008 11:45:42 -0700
Message-ID: <1206902742.6543.35.camel@brick>
References: <200803282148.m2SLmbog012237@imap1.linux-foundation.org>
	 <1206743704.3662.61.camel@localhost.localdomain>
	 <20080328154518.1a178afa.akpm@linux-foundation.org>
	 <1206886107.4224.12.camel@localhost.localdomain>
	 <20080330080748.5b40231d.akpm@linux-foundation.org>
	 <1206891402.4224.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.227]:45996 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYC3Spf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Mar 2008 14:45:35 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1213850wxd.4
        for <linux-scsi@vger.kernel.org>; Sun, 30 Mar 2008 11:45:32 -0700 (PDT)
In-Reply-To: <1206891402.4224.35.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Sun, 2008-03-30 at 10:36 -0500, James Bottomley wrote:
> On Sun, 2008-03-30 at 08:07 -0700, Andrew Morton wrote:
> > On Sun, 30 Mar 2008 09:08:27 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> No, my complaint isn't that we can't do this ... given an infinite
> amount of time, everything can be done.  The problem is that time spent
> on SCSI is a finite and quite precious resource ... I allocate it like
> this:
> 
>      1. Bug fixes
>      2. Driver Maintenance
>      3. Feature Enhancments
>      4. Trivial Cleanups
> 
> However, for 4. I do still require there to be some actual benefit to
> the cleanup (remove a warning, eliminate dead code) etc which is what
> I'm still struggling to find with the __FUNCTION__->__func__
> transformation.

Well, instead of spending energy arguing over this, could you let me
know what files are conflicting with acpi causing a revert...then
I can send you the non-conflicting stuff in a new patch, and get the
rest in through the acpi tree?


Harvey

