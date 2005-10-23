From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH RFC] yet more struct scsi_lun
Date: Sun, 23 Oct 2005 20:48:02 +1000
Message-ID: <435B6A62.8070306@torque.net>
References: <20051023043301.GA22615@havoc.gtf.org> <20051023070011.GA26569@havoc.gtf.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:59600 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1750785AbVJWKrA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 06:47:00 -0400
In-Reply-To: <20051023070011.GA26569@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Douglas Gilbert reminded me of a lun limitation I could kill.  This
> patch applied on top of the previous two lun patches.
> 
> DO NOT APPLY.  For discussion only.
> 
> Changes:
> * add SCSILUN_UNLIMITED for LLDDs without lun limits; set
> 	shost->max_lun = SCSILUN_UNLIMITED;

Which in turn makes me think of applying the same idea
to max_sectors

        shost->max_sectors = MAX_512B_SECTORS_UNLIMITED;

which would be the default unless the HBA (RAID controller
or whatever) really does have a (practical) limit. If a
device beyond the target has a limit, then that is not the
LLD's concern.

Doug Gilbert
