From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [BK PATCH] SCSI updates for 2.6.9
Date: Thu, 21 Oct 2004 09:22:04 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4176F31C.9030401@torque.net>
References: <1098137016.2011.339.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:1748 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S270581AbUJTXWs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 19:22:48 -0400
In-Reply-To: <1098137016.2011.339.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> This represents a significant amount of bug fix and clean up work and
> driver updates (I'm afraid another large qla2xxx firmware update), plus
> one new feature:
> 
> - A scsi target abstraction for the transport classes.  This necessarily
> adds another element to the sysfs path.  However, it's been cooking in
> -mm for over a month now with no reported side effects.
> 
> The update is available from
> 
> bk://linux-scsi.bkbits.net/scsi-for-linus-2.6

James,
Could a unified diff (i.e. normal patch) version of
this be placed somewhere?

Doug Gilbert
