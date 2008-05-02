From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: + scsi-use-get_unaligned_-helpers.patch added to -mm tree
Date: Fri, 02 May 2008 16:54:21 -0700
Message-ID: <1209772461.26173.104.camel@brick>
References: <200805022309.m42N9OJj019849@imap1.linux-foundation.org>
	 <1209772021.3121.72.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:46782 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764497AbYEBXx7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 19:53:59 -0400
Received: by wa-out-1112.google.com with SMTP id j37so590822waf.23
        for <linux-scsi@vger.kernel.org>; Fri, 02 May 2008 16:53:56 -0700 (PDT)
In-Reply-To: <1209772021.3121.72.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Fri, 2008-05-02 at 18:47 -0500, James Bottomley wrote:

> Actually, if you want to be useful, there's far more than just this.
> The whole of SCSI and SAS is peppered with thinks like this.  See for
> example the include/scsi/scsi.h:scsi_to_u32() sas.h:SAS_ADDR() etc.
> 
> Unfortunately, since SCSI is a BE bus, a lot of it is simply roll your
> own inside the .c files.
> 

Sure, I'll go for a look-see, this was just the ones that were greppable
to find.  I'll go through scsi looking for this pattern this weekend.

Harvey

