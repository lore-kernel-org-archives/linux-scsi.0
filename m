From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [patch 08/17] scsi: replace remaining __FUNCTION__ occurrences
Date: Fri, 28 Mar 2008 15:48:25 -0700
Message-ID: <1206744505.24940.71.camel@brick>
References: <200803282148.m2SLmbog012237@imap1.linux-foundation.org>
	 <1206743704.3662.61.camel@localhost.localdomain>
	 <20080328154518.1a178afa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.236]:59980 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbYC1WsZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Mar 2008 18:48:25 -0400
Received: by wx-out-0506.google.com with SMTP id h31so540377wxd.4
        for <linux-scsi@vger.kernel.org>; Fri, 28 Mar 2008 15:48:23 -0700 (PDT)
In-Reply-To: <20080328154518.1a178afa.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Fri, 2008-03-28 at 15:45 -0700, Andrew Morton wrote:
> On Fri, 28 Mar 2008 17:35:04 -0500
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> > > From: Harvey Harrison <harvey.harrison@gmail.com>
> > > 
> > > __FUNCTION__ is gcc-specific, use __func__
> > 
> > I thought we basically agreed
> 
> No.
> 
> > there was no point to this since if it
> > ever became an issue you can do 
> > 
> > #define __FUNCTION__ __func__
> > 
> > inside the include/compiler-xxx.h file
> > 
> 
> It's better to get things right at the original code site, rather than
> adding crufty back-compatibility macros.
> 
> The patches are easy to prepare, easy to review and easy to merge.  There's
> no reason to not do so.

And if they conflict with anything, feel free to drop it file-by-file
and I can respin against another tree once those bits are in.  I'm
here to make it as easy is possible, just point at a git tree.

Harvey

