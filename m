From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive
 gives EBUSY
Date: Tue, 23 Dec 2008 18:30:35 +0200 (EET)
Message-ID: <alpine.LNX.2.00.0812231826370.31316@kai.makisara.local>
References: <20081223161822.9BE36108042@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:55492 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYLWQaj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Dec 2008 11:30:39 -0500
In-Reply-To: <20081223161822.9BE36108042@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Tue, 23 Dec 2008, bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=12207
> 
> 
> 
> 
> 
> ------- Comment #13 from alan@lxorguk.ukuu.org.uk  2008-12-23 08:18 -------
> What may have happened is something else changed to trigger the enforcement of
> that limit on not block paths ?
> 
Something like this ;-) From 2.6.16 st.c has used scsi_execute_async() 
that sends the request to the block layer.

Kai

