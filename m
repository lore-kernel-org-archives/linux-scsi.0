From: Doug Ledford <dledford@redhat.com>
Subject: Re: SCSI Persistent Reservations
Date: Mon, 02 Feb 2004 13:24:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075746272.3248.11.camel@compaq.xsintricity.com>
References: <1074736570.26607.304.camel@swtf.comptex.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:27092 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265777AbUBBSZl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2004 13:25:41 -0500
In-Reply-To: <1074736570.26607.304.camel@swtf.comptex.com.au>
List-Id: linux-scsi@vger.kernel.org
To: Burn Alting <burn@comptex.com.au>
Cc: linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Wed, 2004-01-21 at 20:56, Burn Alting wrote:
> Hi,
> 
> Can anyone point me towards GPL or OpenSource code that uses SCSI-3
> Persistent Reservations. I've looked at Doug Ledford's scsires (version
> 0.7-2) code but it mainly deals with SCSI-2 Reserve/Release commands.
> 
> Thanks in advance

Unfortunately, my experience when writing that code was that I couldn't
find any devices that support persistent reservations, hence the reason
that the code in that package is mostly theoretical and not tested as
far as the persistent reservations are concerned.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


