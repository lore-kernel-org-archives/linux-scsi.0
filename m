From: Matthew Wilcox <willy@debian.org>
Subject: Re: Help - looking for a Linux SCSI testing utility
Date: Fri, 28 May 2004 03:54:20 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040528025420.GG5850@parcelfarce.linux.theplanet.co.uk>
References: <1F6D1D1660975A4887628A011443A1BC0305E3D0@uswaumsx13medge.med.ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:41884 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261987AbUE1CyV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 22:54:21 -0400
Content-Disposition: inline
In-Reply-To: <1F6D1D1660975A4887628A011443A1BC0305E3D0@uswaumsx13medge.med.ge.com>
List-Id: linux-scsi@vger.kernel.org
To: "Edwards, Scott (MED, Kelly IT Resouces)" <James.Edwards@med.ge.com>
Cc: 'Erik Mouw' <erik@harddisk-recovery.com>, linux-scsi@vger.kernel.org

On Thu, May 27, 2004 at 02:41:01PM -0500, Edwards, Scott (MED, Kelly IT Resouces) wrote:
> Just for grins I tried to set it on with scsiinfo and it came back and said
> the write mode page failed.  I am wondering if because the drive is a Serial
> ATA drive and not a real SCSI drive if the mode page stuff works on it?  The

Are you using libata or the older IDE drivers?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
