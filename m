From: Matthew Wilcox <willy@debian.org>
Subject: Re: mptscsih.c: discarded in section `.exit.text' from drivers/bu ilt-in.o
Date: Thu, 5 Feb 2004 20:19:39 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040205201939.GH24334@parcelfarce.linux.theplanet.co.uk>
References: <0E3FA95632D6D047BA649F95DAB60E5703D1A5D4@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:10409 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266381AbUBEUTp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2004 15:19:45 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703D1A5D4@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Alex Williamson <alex.williamson@hp.com>, linux-scsi@vger.kernel.org

On Thu, Feb 05, 2004 at 03:15:45PM -0500, Moore, Eric Dean wrote:
> Are you using 2.6 or 2.4 kernel?  I have recently
> posted different patches against both kernel trees.
> I need to know with driver version your on.
> 
> Eric
> 
> On Thursday, February 05, 2004 12:53 PM, Alex Williamson wrote:
> > 
> >    The MPT Fusion driver seems to have developed a linker problem on
> > ia64.  The latest linux-2.5 bk tree gives me the following:

                      ^^^^^^^^^^^^

He's not using 2.4 ;-)

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
