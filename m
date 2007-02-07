From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source devicedriver
 for new sequence firmware.
Date: Wed, 07 Feb 2007 01:11:32 -0800
Message-ID: <45C997C4.1010705@us.ibm.com>
References: <89FD792A883D4B47AD469FEA2E5D1F9B0F59E7@aime2k302.adaptec.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59153 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030498AbXBGJLg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Feb 2007 04:11:36 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l179BZe6012166
	for <linux-scsi@vger.kernel.org>; Wed, 7 Feb 2007 04:11:35 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l179BZuv089688
	for <linux-scsi@vger.kernel.org>; Wed, 7 Feb 2007 04:11:35 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l179BYSw025649
	for <linux-scsi@vger.kernel.org>; Wed, 7 Feb 2007 04:11:34 -0500
In-Reply-To: <89FD792A883D4B47AD469FEA2E5D1F9B0F59E7@aime2k302.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>

Wu, Gilbert wrote:
> Hi James,
> 
>   We are investigating this issue here. We will update the status when
> we can duplicate the problem here and root cause.

FWIW,

v17 looks good for both SAS/SATA load testing.  The 24-disk x260 seems
to have crapped out after about 800 rounds of load/unload due to the
phys reporting devices, then no devices about 10s later, and then having
the module unloaded before the dead SAS commands finished returning.
Not sure what that's about, though I might also have borked the x260 :(

Though who really is going to reboot the machine 800 times in rapid-fire
succession???

(I'm not trying to slam the v28 sequencer, I'm merely providing a
baseline for comparison between the two.  It may very well be the case
that all the bugs we used to observe with v17 were merely a result of us
poking the sequencer the wrong way....)

--D
