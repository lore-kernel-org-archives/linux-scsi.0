From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: mpt2sas logged messages
Date: Tue, 18 Aug 2009 11:13:10 -0500
Message-ID: <1250611990.6971.9.camel@mulgrave.site>
References: <660360F4F2570145BD872F298951B17AE303DAFA@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759116AbZHRQNS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2009 12:13:18 -0400
In-Reply-To: <660360F4F2570145BD872F298951B17AE303DAFA@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>, Tom Coughlan <coughlan@redhat.com>

On Tue, 2009-08-18 at 09:39 -0600, Moore, Eric wrote:
> On Tuesday, August 18, 2009 7:19 AM,  Ric Wheeler wrote: 
> > 
> > The second is that the mpt2sas driver spews various messages like:
> > 
> > Aug 17 06:55:17 megadeth kernel: mpt2sas0: log_info(0x31120102): 
> > originator(PL), code(0x12), sub_code(0x0102)
> 
> Ric - 
> 
> The code (0x12) means PL_LOGINFO_CODE_ABORT
> The sub_code(0x102) means PL_LOGINFO_SUB_CODE_OPEN_FAILURE_PATHWAY_BLOCKED

To translate this according to the SAS 1.1 specification, a pathway open
failed because a timeout fired before the path could be established.

You can mitigate this by increasing the expander partial pathway timeout
value. (or just move to a more efficient configuration).

James


