From: Matthew Wilcox <willy@debian.org>
Subject: Re: Broken NVRAM Detection in sym53c8xx Driver
Date: Tue, 13 Apr 2004 12:57:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040413115707.GR18329@parcelfarce.linux.theplanet.co.uk>
References: <C18BA5DDB58DD511BD0700C0DF0DD45028B294@NTSERVER4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:61663 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263567AbUDML5I
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 07:57:08 -0400
Content-Disposition: inline
In-Reply-To: <C18BA5DDB58DD511BD0700C0DF0DD45028B294@NTSERVER4>
List-Id: linux-scsi@vger.kernel.org
To: Phil Thompson <philt@4bridgeworks.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, Apr 13, 2004 at 11:53:45AM +0100, Phil Thompson wrote:
> Apologies if this is fixed in a later version - I'm using the sym-2.1.17a
> version of the driver that's in Linux 2.4.25.
> 
> The NVRAM detection code in sym_nvram.c is broken for big endian CPUs. The
> NVRAM is in little endian format, but the code doesn't do the necessary
> conversions for fields bigger than a byte.

You're right, and no this isn't fixed in 2.1.18j.  Bit tricky to fix
given that the checksum has to be calculated across the little-endian
form of the data ... I'll file a bugzilla for this one.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
