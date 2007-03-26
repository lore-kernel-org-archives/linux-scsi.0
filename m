From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 8266] New: Exabyte 1x10 autoloader breaks on
 upgrade
Date: Mon, 26 Mar 2007 15:33:46 -0700
Message-ID: <20070326153346.7290081c.akpm@linux-foundation.org>
References: <200703262150.l2QLopDA003694@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56545 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933674AbXCZWiR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Mar 2007 18:38:17 -0400
In-Reply-To: <200703262150.l2QLopDA003694@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: stable@kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, freelsjd@ornl.gov, Adrian Bunk <bunk@stusta.de>

On Mon, 26 Mar 2007 14:50:51 -0700
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8266
> 
>            Summary: Exabyte 1x10 autoloader breaks on upgrade
>     Kernel Version: 2.6.20.4
>             Status: NEW
>           Severity: high
>              Owner: scsi_drivers-other@kernel-bugs.osdl.org
>          Submitter: freelsjd@ornl.gov
> 
> 
> Most recent kernel where this bug did *NOT* occur: 2.6.20.3
> Distribution: debian/stable/sarge
> Hardware Environment: amd64
> Software Environment: amanda
> Problem Description:
> When upgrading from 2.6.20.3 to 2.6.20.4, the Exabyte 1x10 autoloader would be
> work anymore.  I am using the aic79xx old driver because the aic79xx new driver
> had already broken (see my previous bugs 5268 and 7616)
> 
> Steps to reproduce:
> upgrade from 2.6.20.3 to 2.6.20.4

We appear to have a regression in the stable kernel.

Probably, that regression is in 2.6.21-rc5 as well.
