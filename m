From: Naveen Burmi <naveenb@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Thu, 11 Dec 2003 16:51:18 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03121116511801.15757@naveenb-lnx.cisco.com>
References: <03120118001300.08627@naveenb-lnx.cisco.com> <yquj4qwh3a29.fsf@chaapala-lnx2.cisco.com> <1070486359.1984.51.camel@mulgrave>
Reply-To: naveenb@cisco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:3898 "EHLO
	sj-iport-5.cisco.com") by vger.kernel.org with ESMTP
	id S264886AbTLKLTe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2003 06:19:34 -0500
In-Reply-To: <1070486359.1984.51.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: naveenb@cisco.com, Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com, chaapala@cisco.com


Hi James,

On Thursday 04 December 2003 02:49 am, James Bottomley wrote:
> On Wed, 2003-12-03 at 14:45, Clay Haapala wrote:
> > A couple of related SCSI (not necessarily iSCSI) questions:
> >
> > "If the allowed count has not been exceeded" - The first two commands
> > after a connection has been estabilished will fail with
> > Unit_Attention. What if that first command then also gets a crc error
> > (Aborted_command)?  Will the retry count be large enough?
>
> Yes and it may not be, that's why I think we give you a DID_ code that
> doesn't affect the retry count.
>

Please provide DID_ code(say, DID_IMMEDIATE_RETRY) so that LLD can use it to 
initiate the retry of scsi command without affecting the retry count.

Thanks,
Naveen. 
