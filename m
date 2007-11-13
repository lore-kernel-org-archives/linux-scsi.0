From: Michael Loehr <MLOEHR@de.ibm.com>
Subject: Re: Disabling dev_loss_tmo?
Date: Tue, 13 Nov 2007 11:24:14 +0100
Message-ID: <OF50F972F5.7F1838AD-ONC1257392.0038C0B2-C1257392.003926A2@de.ibm.com>
References: <47396A5B.5040001@linpro.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:26995 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbXKMKYS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Nov 2007 05:24:18 -0500
In-Reply-To: <47396A5B.5040001@linpro.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tore Anderson <tore@linpro.no>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org

Hello Tore,

in recent SLES10 kernels the additional setting "remove_on_dev_loss" allows
to control, if the devices are removed or not. Unfortunately this change
did not find its way upstream yet ...

best regards

  Michael

---
Michael Loehr
Linux for zSeries Development
IBM, Mainz, Germany

