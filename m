From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 11817] SCSI: timing out command for dvd drive
Date: Fri, 24 Oct 2008 10:55:39 -0500
Message-ID: <1224863739.3307.16.camel@localhost.localdomain>
References: <20081024153922.E930D108047@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40730 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754674AbYJXPzm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2008 11:55:42 -0400
In-Reply-To: <20081024153922.E930D108047@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Fri, 2008-10-24 at 08:39 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> ------- Comment #3 from khali@linux-fr.org  2008-10-24 08:39 -------
> Same problem here.

This is Jens' tag cockup:

http://marc.info/?t=122483204900001

Isn't it?

CDs are also no-NCQ devices.

James


