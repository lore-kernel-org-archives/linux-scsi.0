From: Stephen Cameron <steve.cameron@hp.com>
Subject: Re: 2.5.65 and cciss
Date: Thu, 20 Mar 2003 15:06:25 +0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030320090625.GA32689@zuul.cca.cpqcorp.net>
Reply-To: steve.cameron@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: harisri@bigpond.com
Cc: linux-scsi@vger.kernel.org

> Hello,
> 
> Anyone out there using Compaq Smart Array controller 5i (cciss) in 2.5.65?
> 
> It works fine in 2.4.20 and in 2.4.21-pre5, but 2.5.65 panics and asking me to 
> pass on the right root= option. But I have verified it be identical to that 
> of 2.4.x
> 

Yeah, I am using it.  Are you compiling cciss statically or as a module?
If statically, are you using labels in your fstab?  In which case,
you typically (e.g. redhat 8) MUST have an initrd image to get the right
version of "mount" around that understands labels... (just a wild guess).

Describe your configuration in more detail.

-- steve
