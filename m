From: Ewan Milne <emilne@redhat.com>
Subject: RE: Question on SCSI target scan
Date: Mon, 18 Nov 2013 12:28:32 -0500
Message-ID: <1384795712.3839.6.camel@localhost.localdomain>
References: <5645D6F831469342AF2BC26CC827D68C5940032A27@BRM-EXCH-3.corp.brocade.com>
	 <94D0CD8314A33A4D9D801C0FE68B4029547B9343@G9W0745.americas.hpqcorp.net>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab3KRR3O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Nov 2013 12:29:14 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029547B9343@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Ramesh Chikkanayakanahally <rcnagara@Brocade.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>

On Fri, 2013-11-15 at 23:53 +0000, Elliott, Robert (Server Storage)
wrote:
> Beware that just because the LUN inventory is the same doesn't mean
> the logical units are the same.  A logical unit at LUN X might have been 
> deleted and another logical unit created and assigned to LUN X, but
> now containing different content.  You need to check the logical unit
> name (in the Device Identification VPD page) too.
> ---
> Rob Elliott    HP Server Storage
> 

If the properties of the volume behind a particular LUN are changed,
shouldn't something like ASC/ASCQ 3F 03 INQUIRY DATA HAS CHANGED,
3F 04 DEVICE IDENTIFIER CHANGED be reported?  Or can we not expect
this if a LUN is removed and then re-added without an intervening
REPORT LUNS command?  (In that case, the REPORT LUNS data returned
will be no different.)

-Ewan


