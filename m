From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: linux 2.6 "seagate" scsi hardware driver ?incomplete?
Date: Tue, 1 Feb 2005 14:02:00 +0000
Message-ID: <20050201140200.GB10088@parcelfarce.linux.theplanet.co.uk>
References: <Pine.GSO.4.53.0502010159390.22349@amos.bath.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:50834 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262021AbVBAOCD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Feb 2005 09:02:03 -0500
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.53.0502010159390.22349@amos.bath.ac.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: S Iremonger <exxsi@bath.ac.uk>
Cc: linux-scsi@vger.kernel.org

On Tue, Feb 01, 2005 at 02:11:48AM +0000, S Iremonger wrote:
> I would like if anybody out there knwos why linux-2.6 (well, at
>   least 2.6.8.1 and 2.6.10) seems to have "seagate" as an
>   "incomplete or experimental" driver, at least that it
>   does not appear in the SCSI low level drivers list
>   unless the "enabled incomplete and/or experimental" drivers
>   config option is enabled (not sure of the CONFIG_ option
>   myself).

Actually, it's worse than that:

config SCSI_SEAGATE
        tristate "Seagate ST-02 and Future Domain TMC-8xx SCSI support"
        depends on X86 && ISA && SCSI && BROKEN

The driver is marked as BROKEN so it's even a candidate for deletion unless a
maintainer steps up to fix it.  Could you do that?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
