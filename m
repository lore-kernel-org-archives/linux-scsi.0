From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 08/17] scsi: replace remaining __FUNCTION__ occurrences
Date: Fri, 28 Mar 2008 15:45:18 -0700
Message-ID: <20080328154518.1a178afa.akpm@linux-foundation.org>
References: <200803282148.m2SLmbog012237@imap1.linux-foundation.org>
	<1206743704.3662.61.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753217AbYC1WpX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 18:45:23 -0400
In-Reply-To: <1206743704.3662.61.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, harvey.harrison@gmail.com

On Fri, 28 Mar 2008 17:35:04 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> > From: Harvey Harrison <harvey.harrison@gmail.com>
> > 
> > __FUNCTION__ is gcc-specific, use __func__
> 
> I thought we basically agreed

No.

> there was no point to this since if it
> ever became an issue you can do 
> 
> #define __FUNCTION__ __func__
> 
> inside the include/compiler-xxx.h file
> 

It's better to get things right at the original code site, rather than
adding crufty back-compatibility macros.

The patches are easy to prepare, easy to review and easy to merge.  There's
no reason to not do so.
