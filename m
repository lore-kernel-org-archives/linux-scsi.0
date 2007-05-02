From: "Dr. David Alan Gilbert" <dave@treblig.org>
Subject: LTO 4 encryption support?
Date: Wed, 2 May 2007 09:56:32 +0100
Message-ID: <20070502085632.GA11062@gallifrey>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:45081 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992956AbXEBJiW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 May 2007 05:38:22 -0400
Received: from mx.treblig.org ([80.68.94.177])
	by tallyho.bytemark.co.uk with esmtp (Exim 4.52)
	id 1HjBHx-00068w-ER
	for linux-scsi@vger.kernel.org; Wed, 02 May 2007 09:38:21 +0000
Received: from dg by mx.treblig.org with local (Exim 4.50)
	id 1HjAdU-0002xa-A8
	for linux-scsi@vger.kernel.org; Wed, 02 May 2007 09:56:32 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
  It is said that LTO 4 drives are starting to be available and
that they have encryption support built in.

Does anyone know anything about the encryption stuff on it?
In particular:

  1) How can I tell if it is using encryption?
  2) How can I set the encryption key on the drive?

I guess my biggest worry would be running a drive which I believed
wasn't encrypting and then only find out when I replace the drive
that it was encrypted; with some default key I didn't know.
However it would be nice to run with encryption if I could then
store that key in a few nice secure places.

Suggestions welcome.

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
