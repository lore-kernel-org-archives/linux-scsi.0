From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] scsi: delete decade+ obsolete aic7xxx_old driver
Date: Tue, 17 Sep 2013 20:11:30 -0400
Message-ID: <20130918001130.GA16331@windriver.com>
References: <y687fpks4kdsmfuadq4cykip.1379384036544@email.android.com>
 <52386730.4060508@suse.de>
 <1379448641.2213.18.camel@dabdike>
 <5238BB4A.8000309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:35513 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3IRALF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Sep 2013 20:11:05 -0400
Content-Disposition: inline
In-Reply-To: <5238BB4A.8000309@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, linux-scsi list <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org

[Re: [PATCH] scsi: delete decade+ obsolete aic7xxx_old driver] On 17/09/2013 (Tue 16:27) Doug Ledford wrote:

> On 09/17/13 16:10, James Bottomley wrote:
> 
> > OK, so do we have any real evidence that no-one uses this driver?  Does
> > any distro actually compile it, for instance?
> 
> Red Hat doesn't use it in any of their products (and it hasn't been the
> preferred driver since about the old Red Hat Linux 7.0 days).

The oldest ubuntu machine I could find was running a 2.6.32 kernel and
even back then, they weren't building/enabling this driver either.

Paul.
--

> 
> 
> -- 
> Doug Ledford <dledford@redhat.com>
>               GPG KeyID: 0E572FDD
> 	      http://people.redhat.com/dledford
> 
