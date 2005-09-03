From: Robert Valentan <R.Valentan@solid-soft.at>
Subject: Re: SCSI tape problems...   (solved?)
Date: Sat, 03 Sep 2005 16:02:25 +0200
Message-ID: <4319ACF1.7050307@solid-soft.at>
References: <430B73E9.7080207@solid-soft.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.solid.co.at ([193.83.215.58]:44738 "EHLO
	mail.solid-soft.at") by vger.kernel.org with ESMTP id S1751458AbVICOCb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Sep 2005 10:02:31 -0400
In-Reply-To: <430B73E9.7080207@solid-soft.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: john@stoffel.org, linux-scsi@vger.kernel.org

Hi!

I think, I have found the problem with SCSI-Tapes
(Error 80000).
I have detect, that the sgraidmon is testing all sg-devices,
and if the inquiry-command fails (timeout) it sends a bus-
reset-command (ioctl) as "recovery"-operation !
After stopping the sgraidmon I have no more problems with
the tape.

Can anybody confirm this?


-- 
Robert Valentan
