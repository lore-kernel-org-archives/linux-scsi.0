From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Kernel 2.6.x hangs with Symbios Logic 53c1010 Ultra3 SCSI Adapter
Date: Fri, 5 Nov 2004 18:07:41 +0000
Message-ID: <20041105180741.GZ24690@parcelfarce.linux.theplanet.co.uk>
References: <C18BA5DDB58DD511BD0700C0DF0DD4501EEC6A@NTSERVER4> <04Nov5.120116est.333377@cyborg.cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:25571 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262715AbUKESHm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Nov 2004 13:07:42 -0500
Content-Disposition: inline
In-Reply-To: <04Nov5.120116est.333377@cyborg.cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: 'SUPPORT' <support@4bridgeworks.com>, 'Matthew Wilcox' <matthew@wil.cx>, 'Thomas Babut' <thomas@babut.net>, 'Linux SCSI' <linux-scsi@vger.kernel.org>

On Fri, Nov 05, 2004 at 12:01:40PM -0500, Tony Battersby wrote:
> > I have also seen drives that do unexpected disconnects if they get
> sent PPR.
> 
> I too have seen a single-ended Exabyte Mammoth tape drive go to
> unexpected bus free right after receiving the second byte of the PPR
> extended message (01 06 - bus free).  Evidently it does not expect to
> receive an extended message of that length.
> 
> I submitted a patch to sym53c8xx_2 in lk 2.4.x a few days ago to avoid
> PPR on a SE or HVD bus, which fixes the problem for me.

Yup, but that won't solve Thomas Babut's problem, because his drive is
in LVD mode.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
