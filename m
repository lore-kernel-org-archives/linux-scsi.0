From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SCSI Persistent Reservations
Date: Sun, 13 Jun 2004 11:43:24 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CBB13C.1020000@torque.net>
References: <1074736570.26607.304.camel@swtf.comptex.com.au> <1075746272.3248.11.camel@compaq.xsintricity.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:22542 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264966AbUFMBr0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jun 2004 21:47:26 -0400
In-Reply-To: <1075746272.3248.11.camel@compaq.xsintricity.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Burn Alting <burn@comptex.com.au>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

Doug Ledford wrote:
> On Wed, 2004-01-21 at 20:56, Burn Alting wrote:
> 
>>Hi,
>>
>>Can anyone point me towards GPL or OpenSource code that uses SCSI-3
>>Persistent Reservations. I've looked at Doug Ledford's scsires (version
>>0.7-2) code but it mainly deals with SCSI-2 Reserve/Release commands.
>>
>>Thanks in advance
> 
> 
> Unfortunately, my experience when writing that code was that I couldn't
> find any devices that support persistent reservations, hence the reason
> that the code in that package is mostly theoretical and not tested as
> far as the persistent reservations are concerned.

Further to this thread, I have added a utility called
sg_persist to sg3_utils package (version 1.07 beta)
that permits low level access
to the SCSI Persistent Reservation In and Out commands.
I can do a limited amount of testing with my equipment
so I would be keen for others to test the utility.

See the news section at the top of http://www.torque.net/sg

Doug Gilbert

