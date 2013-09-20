From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Fri, 20 Sep 2013 13:13:30 +0300
Message-ID: <20130920101330.GZ2924@reaktio.net>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
 <bug-60644-11613-6lTrK8p8yG@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:57944 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab3ITKNc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Sep 2013 06:13:32 -0400
Content-Disposition: inline
In-Reply-To: <bug-60644-11613-6lTrK8p8yG@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Tue, Sep 17, 2013 at 11:00:21AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=60644
> 
> --- Comment #32 from liveaxle@live.com ---
> Hi .
> 
> This bug is still present in 3.12-rc1 as of today's tests .
> 

You might want to try the latest P17 firmware aswell, it has been out for a couple of weeks now.
There's not much in the changelogs, but it seems to fix some other SGPIO related issues at least.

-- Pasi

