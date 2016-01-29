From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
Date: Fri, 29 Jan 2016 13:08:59 -0600
Message-ID: <01C3BBA0-3D1A-461A-9EEF-512A57707325@cs.wisc.edu>
References: <bug-111441-11613@https.bugzilla.kernel.org/> <56AAC605.1080707@cs.wisc.edu> <9cf7d536fcc44d9d8f35d81503543497@XCH-ALN-006.cisco.com> <36266784-E570-406E-8C3A-56D0F728768B@cs.wisc.edu> <a331d83963b64d7da77352b01c1d10da@XCH-ALN-006.cisco.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53541 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbcA2TJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2016 14:09:07 -0500
In-Reply-To: <a331d83963b64d7da77352b01c1d10da@XCH-ALN-006.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc: "bugzilla-daemon@bugzilla.kernel.org" <bugzilla-daemon@bugzilla.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On Jan 29, 2016, at 6:04 AM, Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com> wrote:
> 
> Actually this server uses both cases: Local taregts (since it is OpenStack server) and remote targets as it tries to mount 4 remotefile systems.  
> 
> You are correct, I always use the same box I just change the kernel it is using to boot. No other changes to the environment. I do not mind to load a test kernel without that suspected patch, just get me the RPM.
> 

I do not know what you mean. I think the patch I sent will fix the sysfs errors caused due to alua not being setup properly on your system and scsi_dh_alua failing to attach. That patch should be applied to the 4.4 upstream kernel. Are you saying you want me to make you a kernel rpm?