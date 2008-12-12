From: "Greg Freemyer" <greg.freemyer@gmail.com>
Subject: Re: Intel X25-M MLC SSD benchmarks
Date: Fri, 12 Dec 2008 13:10:42 -0500
Message-ID: <87f94c370812121010g7d19471en6efb273bd504dad3@mail.gmail.com>
References: <AclbDGOLOskD7sbdTh+kIygApfPXZg==>
	 <83CA05F64804AF43B8F733C4ABDFAA51022D04D4@mail1.bitband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:49815 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248AbYLLSKq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Dec 2008 13:10:46 -0500
In-Reply-To: <83CA05F64804AF43B8F733C4ABDFAA51022D04D4@mail1.bitband.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raz Ben-Yehuda <razb@bitband.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Dec 10, 2008 at 4:15 PM, Raz Ben-Yehuda <razb@bitband.com> wrote:
> Hello
> I am wondering if anyone tried Intel new disks. I benchmark them and I
> am a bit confused.
> According to the spec a single disk should provide 70MB/s write and 250
> MB/s read. Reads are ok. I am reaching this number, but writes are bad.
> With writes I am getting 20MB/s.
> I am using a dd for the test, and a deadline-line scheduler.
>
> Thank you
> Raz

FYI:
Some recent kernel's have performance bugs in /dev/zero.  (The bug may
only exist ins SuSE kernels, not sure.)

Be sure to baseline it before you trust it for any benchmarks.

My current machine/kernel is plenty fast to use but you need to be
sure and it only takes a minute.

# dd if=/dev/zero of=/dev/null bs=1M count=100000
100000+0 records in
100000+0 records out
104857600000 bytes (105 GB) copied, 33.4257 s, 3.1 GB/s

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
