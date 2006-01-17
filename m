From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 2/8] fusion - mptsas, increase discovery timout to 300
 seconds
Date: Tue, 17 Jan 2006 13:45:11 +1000
Message-ID: <43CC6847.8050708@torque.net>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAC7E@NAMAIL2.ad.lsil.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:4556 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751342AbWAQDoo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 22:44:44 -0500
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAC7E@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

Moore, Eric wrote:
> Increase the port enable timeout only for SAS from 30 to 300 seconds.
> A customer request for the handling large topologies.

Eric,
I have seen various reports concerning SAS HBAs taking
"forever" to initialize/discover (various HBA manufacturers,
various OSes). Perhaps you could enlighten me why these
timeouts need to be so large.

Also if a SAS domain does not contain a fanout expander,
doesn't that limit the domain to around 128 or 256
SCSI devices (sum of scsi initiator and target ports)?
If so, perhaps the timeout could be one of two values,
a larger value if a fanout expander was found in
the most recent discover process.

Doug Gilbert
