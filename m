From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] sym53c8xx_2 pci_device_id list terminators
Date: Thu, 11 Sep 2003 01:20:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030911002029.GE21596@parcelfarce.linux.theplanet.co.uk>
References: <Pine.LNX.4.44.0309101635060.27316-100000@humbolt.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:36480 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266112AbTIKAUf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 20:20:35 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0309101635060.27316-100000@humbolt.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: groudier@free.fr, linux-scsi@vger.kernel.org

On Wed, Sep 10, 2003 at 04:40:31PM -0500, Matt Domsch wrote:
> Gerard, I found that the sym53c8xx_2 driver has two pci_device_id lists, 
> neither of which are 0-terminated.  This causes the pci detection routine 
> to walk off the end of the list into space and causes an oops.  Often this 
> isn't a problem, as the things after those lists are zeros, but we can't 
> count on it, and it just bit me. :-)
> 
> Patch below against 2.6.0-test5 + recent BK.  Please apply ASAP.

Hi Matt.  Since nobody's heard from Gerard in almost 2 years, I've
taken over maintaining this driver (at least until he comes back).
This change was mine, and I'll get this fixed ASAP.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
