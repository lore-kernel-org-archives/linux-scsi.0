From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: ses: fix VPD inquiry overrun
Date: Wed, 30 Jul 2008 10:35:47 -0700
Message-ID: <1217439347.23389.138.camel@brick>
References: <1217349505.6103.15.camel@localhost.localdomain>
	 <48903800.7000008@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:44091 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYG3Rfr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 13:35:47 -0400
Received: by yw-out-2324.google.com with SMTP id 9so74708ywe.1
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jul 2008 10:35:46 -0700 (PDT)
In-Reply-To: <48903800.7000008@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2008-07-30 at 12:44 +0300, Boaz Harrosh wrote:
> James Bottomley wrote:

> Harvey where are these bitwise accessors that do an *aligned* access on a 
> void pointer. the equivalent of:
> 	u16 = be16_to_cpup((const __be16 *p)&buff[x]);
> Where I know that x above is some even offset.
> 
> I've seen you sent them but I can't find them in my tree
> 

They weren't accepted.  No need to duplicate be16_to_cpup etc.

Cheers,

Harvey

