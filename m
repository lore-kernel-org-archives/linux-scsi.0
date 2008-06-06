From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Fri, 6 Jun 2008 11:03:45 -0700
Message-ID: <20080606110345.581fdc77.akpm@linux-foundation.org>
References: <200806010415.05290.chris2553@googlemail.com>
	<20080605221709.f248eb90.akpm@linux-foundation.org>
	<200806060607.29460.chris2553@googlemail.com>
	<20080605232145.cdae753f.akpm@linux-foundation.org>
	<20080605232538.fb85021e.akpm@linux-foundation.org>
	<1212765742.16182.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539AbYFFSDz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 14:03:55 -0400
In-Reply-To: <1212765742.16182.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: chris2553@googlemail.com, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>

On Fri, 06 Jun 2008 10:22:22 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Thu, 2008-06-05 at 23:25 -0700, Andrew Morton wrote:
> > On Thu, 5 Jun 2008 23:21:45 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > <watches wodim wibble for five minutes then report "CD/DVD-Recorder
> > > not ready."  Pretends not to have noticed.>
> > 
> > It goes much better when the CD is inserted upside up.
> 
> So I can close this regression if I send you a pack of CD ring labels
> with "other way up" on them for you to affix to the underside of your
> CDs ... ?
> 

Would prefer double-sided CDs.

Is this 20-second-delay thing known-about/expected/etc?
