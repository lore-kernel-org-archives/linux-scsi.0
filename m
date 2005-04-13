From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: PATCH [0/5]  qla2xxx: remote port rework...
Date: Wed, 13 Apr 2005 20:42:26 +0100
Message-ID: <20050413194226.GS8669@parcelfarce.linux.theplanet.co.uk>
References: <20050413191548.GI9703@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:21645 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261253AbVDMTmb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 15:42:31 -0400
Content-Disposition: inline
In-Reply-To: <20050413191548.GI9703@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Wed, Apr 13, 2005 at 12:15:48PM -0700, Andrew Vasquez wrote:
> 1) Remove internal command queuing.  This entails removal of the
>    driver's *_queue lists as well as modifications and removal of
>    routines which used them.  With the queuing removed -- the
>    driver will be unable to tolerate cable-pulls.  Thus we depend
>    on the next patch for support.

Wow, congratulations.  I'm still struggling to do this to sym2.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
