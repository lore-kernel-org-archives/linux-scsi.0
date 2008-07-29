From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: tools support for non-512 byte sector sizes
Date: Tue, 29 Jul 2008 15:03:43 -0400
Message-ID: <yq1y73kpl68.fsf@sermon.lab.mkp.net>
References: <660360F4F2570145BD872F298951B17A3AC7E3B3@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:13070 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbYG2TEf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jul 2008 15:04:35 -0400
In-Reply-To: <660360F4F2570145BD872F298951B17A3AC7E3B3@cosmail03.lsi.com> (Eric Moore's message of "Tue\, 29 Jul 2008 12\:43\:23 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "rwheeler@redhat.com" <rwheeler@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Jim Meyering <jim@meyering.net>

>>>>> "Eric" == Moore, Eric <Eric.Moore@lsi.com> writes:

Eric> I was wondering about formatting drives with DIF support??
Eric> Martin told me he is using sg_format, however it doesn't support
Eric> type 3 protection format, which has 6 byte application tag.

I have only been testing Type 3 with scsi_debug (which conveniently
avoids the formatting step).

I doubt we will see any disk drives that support Type 3.  The way the
standard is written, a drive can either do Type 1+2 or Type 1+3.  Type
2+3 is not a possible combination.

In any case.  If you happen to own a Type 3-capable device you format
it exactly like if it had been a Type 2.  I.e. set PINFO=1 and
RTO_REQ=1 in FORMAT UNIT.  sg_format can already do this.

-- 
Martin K. Petersen	Oracle Linux Engineering

