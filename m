From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: IP/ethernet/networking-over-SCSI.
Date: Tue, 25 Jan 2005 19:28:26 +0000
Message-ID: <20050125192826.GX31455@parcelfarce.linux.theplanet.co.uk>
References: <Pine.GSO.4.53.0501251546570.25246@amos.bath.ac.uk> <20050125110113.54cf5725@dxpl.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:58331 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262080AbVAYT2g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2005 14:28:36 -0500
Content-Disposition: inline
In-Reply-To: <20050125110113.54cf5725@dxpl.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <shemminger@osdl.org>
Cc: S Iremonger <exxsi@bath.ac.uk>, linux-net@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jan 25, 2005 at 11:01:13AM -0800, Stephen Hemminger wrote:
> On Tue, 25 Jan 2005 16:19:12 +0000 (GMT)
> S Iremonger <exxsi@bath.ac.uk> wrote:
> 
> > 
> > For some purposes at the moment, working IP-over-SCSI could be rather
> >   handy... ;-).
> 
> You probably are looking for:
> 	http://linux-iscsi.sourceforge.net/

That's SCSI-over-IP, a rather different concept ;-)

I think he's looking for an implementation of
http://www.faqs.org/rfcs/rfc2143.html

I wonder if that's the same Ben Elliston who's now working on GCC ...

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
