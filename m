From: Matthew Wilcox <willy@debian.org>
Subject: Re: DAC960 + sym53c8xx conflict
Date: Mon, 16 Aug 2004 12:20:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040816112034.GC28995@parcelfarce.linux.theplanet.co.uk>
References: <1092628387.2548.14.camel@fs2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:5306 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267543AbUHPLUf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 07:20:35 -0400
Content-Disposition: inline
In-Reply-To: <1092628387.2548.14.camel@fs2>
List-Id: linux-scsi@vger.kernel.org
To: Michael <mozstuff@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Aug 15, 2004 at 10:53:07PM -0500, Michael wrote:
> I've got a 4-processor Intel SC450NX-based system with motherboard
> Sym53c896 dual controller driven a Mylex Acceleraid 200. The motherboard
> also has a sym53c810a which drives a Sony SDT-9000 tape drive. This
> combo has always worked well until I tried updating to a 2.6 kernel.
> 
> When I load 2.6 (tried 2.6. - 2.6.8-rc4 (mm tree too)) every works OK
> until I load the sym53c8xx module. When that module is loaded all access
> to the drives connected to the DAC960 vanishes. I get no errors and the
> system is not locked up. Any attempt to access the disks on the DAC960
> simply hangs.
> 
> Any ideas? I hacked teh sym driver to remove all support for the 896
> chip, but it didn't.

On 2.4, did you get the message:

        printf_info("%s: not initializing, driven by RAID controller.\n",
                                            sym_name(device));

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
