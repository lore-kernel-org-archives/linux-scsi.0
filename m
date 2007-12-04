From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Tue, 4 Dec 2007 13:16:18 +0100
Message-ID: <20071204121618.GA26132@elte.hu>
References: <6A73BEE8-9D45-4B75-8756-3008A4B1FDF4@orcon.net.nz> <20071203011732.2CEABDBA2@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:55563 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbXLDMQz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 07:16:55 -0500
Content-Disposition: inline
In-Reply-To: <20071203011732.2CEABDBA2@gherkin.frus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bob Tracy <rct@gherkin.frus.com>
Cc: Michael Cree <mcree@orcon.net.nz>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>


* Bob Tracy <rct@gherkin.frus.com> wrote:

> Finally got back in town.  Starting the git-bisect process.  I've got 
> a relatively slow network connection, and the PWS 433au isn't exactly 
> what I would call "fast" by modern standards, so bear with me while I 
> get things set up and crank through this.  The clone of the 2.6 tree 
> will take several more hours to finish downloading.  I anticipate the 
> best pace I'll be able to manage after that is two iterations in a 24- 
> hour period.

once you are done with the download of the initial cloned git repository 
(which is 200MB+), all the bisection steps will be local and you'll be 
only limited by kernel rebuild speed and by bootup and testing speed, 
not by network bandwidth.

( once you have the cloned repository i'd suggest for you to keep it - 
  that way you can track susequent kernels via "git-pull" and it uses a 
  very network-efficient delta protocol. )

	Ingo
