From: Matthias Kaehlcke <matthias@kaehlcke.net>
Subject: Re: [PATCH] Fusion MPT: Convert inactive_list_mutex in a mutex
Date: Mon, 5 May 2008 17:21:53 +0200
Message-ID: <20080505152153.GD11462@traven>
References: <20080504180544.GN20036@traven> <1209997566.3163.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.riseup.net ([204.13.164.18]:53377 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbYEEPWF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2008 11:22:05 -0400
Content-Disposition: inline
In-Reply-To: <1209997566.3163.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Eric.Moore@lsi.com, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

El Mon, May 05, 2008 at 09:26:06AM -0500 James Bottomley ha dit:

> On Sun, 2008-05-04 at 20:05 +0200, Matthias Kaehlcke wrote:
> > MPT Fusion: The semaphore inactive_list_mutex is used as a
> > mutex. Convert it to the mutex API
> > 
> > Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
> 
> Um, it would at least vaguely help if you checked the tree; even
> actually trying to apply the patch would have told you.  I know the
> email notifications from scsi misc can sometimes get lost.
> 
> commit ed5f606fef22e515331aab4c1f927775cf4af70e
> Author: Matthias Kaehlcke <matthias@kaehlcke.net>
> Date:   Sun Mar 9 12:16:27 2008 +0100
> 
>     [SCSI] mpt fusion: convert inactive_list_mutex to a mutex

apologizes for my ignorance, which tree exactly should i have checked
for this patch? is it linux/kernel/git/jejb/scsi-misc-2.6.git? 

regards

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

     Nationalism is an infantile disease. It is the measles of mankind
                         (Albert Einstein)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
