From: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [patch 10/17] scsi: gdth.c use unaligned access helpers
Date: Fri, 3 Oct 2008 10:24:22 -0700
Message-ID: <590657100810031024r48b6d52ctce83fb81a41f758@mail.gmail.com>
References: <200809222156.m8MLum2c032291@imap1.linux-foundation.org>
	 <1223050981.3230.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:25869 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbYJCRYX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Oct 2008 13:24:23 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1726848wfd.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Oct 2008 10:24:22 -0700 (PDT)
In-Reply-To: <1223050981.3230.21.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, bharrosh@panasas.com, Matthew Wilcox <matthew@wil.cx>

On Fri, Oct 3, 2008 at 9:23 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> OK, there are two ways to go on this.  Either we eliminate the current
> SCSI wrappers for this, or we extend them and use them.  Matthew Wilcox
> already has a patch for the extensions, so do we have a consensus?
>

Pointers to the extensions please.

Harvey
