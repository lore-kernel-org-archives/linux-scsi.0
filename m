From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Fri, 29 Oct 2004 09:48:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF0FDEA552.68780C37-ON88256F3C.005B8D98-88256F3C.005C6A0F@us.ibm.com>
References: <20041029141217.GC32712@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:49860 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263358AbUJ2QtD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 12:49:03 -0400
In-Reply-To: <20041029141217.GC32712@marowsky-bree.de>
List-Id: linux-scsi@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>EMC at least partially calls said
>world-wide unique identifier the "LUN's WWN" though.

I'm not surprised.  We all know how common it is to call a logical unit 
(LU) a LUN, and I've also seen the made-up "LUN ID" (and of course the 
truly ridiculous "LUN number," loved by all those people who key their PIN 
number into the ATM machine).

>And if we are nitpicking, it's EVPD. ;-)

Oh, we're definitely nitpicking, but EVPD is the abbreviation for the 
"Enable Vital Product Data" bit in an Inquiry CDB that tells the target 
you're asking for the Vital Product Data (VPD).  At least that's how the 
SCSI standard uses it.  Maybe EMC has its own terminology here too.

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems
