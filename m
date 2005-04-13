From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: PATCH [6/5]  qla2xxx: update version :)
Date: Wed, 13 Apr 2005 14:24:36 -0700
Message-ID: <20050413212436.GC14857@plap.qlogic.org>
References: <20050413205007.GA14857@plap.qlogic.org> <1113425828.4933.39.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:54640 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261181AbVDMVYh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 17:24:37 -0400
Content-Disposition: inline
In-Reply-To: <1113425828.4933.39.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>

On Wed, 13 Apr 2005, James Bottomley wrote:

> On Wed, 2005-04-13 at 13:50 -0700, Andrew Vasquez wrote:
> > -#define QLA2XXX_VERSION      "8.00.02b4-k"
> > +#define QLA2XXX_VERSION      "8.00.02b5-k"
> 
> so, erm, removing about 4,000 lines of code and embracing a new
> transport infrastructure doesn't even warrant a minor minor number
> change in the driver ... ?
> 

Ok, here's the deal -- QLogic's standard 8.01.00 driver contains the
following major additions:

* support for 4Gb ISPs
* FCIP support

I had considered going to 8.01.00-k or even 8.00.03-k for the upstream
kernel, but decided against it to minimize the potential for confusion
with users expecting comparable features and fixes with the two
drivers -- since there are QLogic standard 8.01.00 and 8.00.03
releases.

Yes, the upstream driver has just undergone some serious rework, and
in all honesty I'm rather ambivalent with respect to what the version
number is.  Nevertheless, this transition is going to be confusing and
had hoped that when the 4Gb support patch is added (after the dust
settled with the latest set of patches) the version number would then
pivot to 8.01.xx-k.

I'll feel fairly comfortable with the 4Gb upstream patches with about
another week of testing.

Anyway, given that, I'm open to suggestions...

--
av
