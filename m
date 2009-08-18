From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: mpt2sas logged messages
Date: Tue, 18 Aug 2009 11:02:39 -0600
Message-ID: <660360F4F2570145BD872F298951B17AE303DB55@cosmail03.lsi.com>
References: <1250611990.6971.9.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:54843 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759427AbZHRRCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 13:02:49 -0400
In-Reply-To: <1250611990.6971.9.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Ric Wheeler <rwheeler@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>, Tom Coughlan <coughlan@redhat.com>

On Tuesday, August 18, 2009 10:13 AM,  James Bottomley wrote:
> > The code (0x12) means PL_LOGINFO_CODE_ABORT
> > The sub_code(0x102) means 
> PL_LOGINFO_SUB_CODE_OPEN_FAILURE_PATHWAY_BLOCKED
> 
> To translate this according to the SAS 1.1 specification, a 
> pathway open
> failed because a timeout fired before the path could be established.
> 
> You can mitigate this by increasing the expander partial 
> pathway timeout
> value. (or just move to a more efficient configuration).
> 

I was telling Ric it was something else in seperate email.  The pathway was blocked due to two initiors establishing a connection to single port. That woudl be the case if he wasn't using a sata multiplexor.


anyways, if the pathway timeout is the issue, then I believe you can set the pathway timeout value using Dougs smp tools, smp_phy_control , setting the --pptv command line option.

http://sg.danny.cz/sg/smp_utils.html