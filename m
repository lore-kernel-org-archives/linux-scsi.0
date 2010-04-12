From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: SCSI persistent reservation terms
Date: Mon, 12 Apr 2010 10:09:35 -0500
Message-ID: <1271084975.4428.12.camel@mulgrave.site>
References: <3BEB5F9B6605A140847DEEEDF7439C5D040A06C8@CORPUSMX50A.corp.emc.com>
	 <1270666077.3332.10.camel@haakon2.linux-iscsi.org>
	 <3BEB5F9B6605A140847DEEEDF7439C5D04125E92@CORPUSMX50A.corp.emc.com>
	 <4BC32621.8080706@interlog.com>
	 <3BEB5F9B6605A140847DEEEDF7439C5D04125F6D@CORPUSMX50A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab0DLPJm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Apr 2010 11:09:42 -0400
In-Reply-To: <3BEB5F9B6605A140847DEEEDF7439C5D04125F6D@CORPUSMX50A.corp.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lemons_terry@emc.com
Cc: dgilbert@interlog.com, nab@linux-iscsi.org, linux-scsi@vger.kernel.org

On Mon, 2010-04-12 at 10:53 -0400, lemons_terry@emc.com wrote:
> Hi Doug
> 
> Thanks for the reply.  I did stare at Table 51 before writing my email.
> The 'Processing' language for the first and third rows is exactly the
> same; that's why I'm still confused!
> 
> I've printed and read (several times) both section 5.7 'Reservations'
> and sections 6.13 'PERSISTENT RESERVE IN' / 6.14 'PERSISTENT RESERVE
> OUT'.  But I don't see any language that explains the difference between
> 'write_exclusive' and 'write_exclusive_registrants_only'.  If this is in
> there, I apologize for not seeing it.

The change is in the definition of the "reservation holder" for the
reservation (5.7.10).  For exclusive all registrants reservations, the
holder is all registered initiators; otherwise it's the initiator port
the reservation was issued on.

James


