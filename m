From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Mon, 10 Mar 2008 20:02:25 +0100
Message-ID: <20080310200225.1b9914e3@szpak>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
	<1204848652.3062.100.camel@localhost.localdomain>
	<200803101519.m2AFJCJS032509@colby.verdasys.com>
	<1205163386.2941.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.wp.pl ([212.77.101.5]:25834 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbYCJTDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2008 15:03:08 -0400
Received: from a3gw.hmg.inpg.fr (HELO szpak) (janek_listy@[194.254.65.43])
          (envelope-sender <janek_listy@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with SMTP
          for <linux-scsi@vger.kernel.org>; 10 Mar 2008 20:03:03 +0100
In-Reply-To: <1205163386.2941.14.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org

James Bottomley said:     (by the date of Mon, 10 Mar 2008 10:36:26 -0500)


> I'm afraid the only way to confirm this theory definitively will be with
> the destructive disktest

you can try this destructive test:

  badblocks -c 10240 -s -w -t random -v /dev/sdc

or use smaller value for -c if you wish.

-- 
Janek Kozicki                                                         |
