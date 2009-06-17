From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 0/3] update blacklist matching to be usable by the
 transport classes
Date: Wed, 17 Jun 2009 15:00:44 -0400
Message-ID: <1245265244.8585.94.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38360 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932677AbZFQTAo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jun 2009 15:00:44 -0400
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 936ED8EE10E
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2009 12:00:47 -0700 (PDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
	by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YGF2GqqsQyRB for <linux-scsi@vger.kernel.org>;
	Wed, 17 Jun 2009 12:00:47 -0700 (PDT)
Received: from [192.168.10.224] (newmulgrave.ext.hansenpartnership.com [192.168.10.224])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 343638EE0F1
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2009 12:00:47 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Since the discovery of a problem with Information Unit transfers on an
Ultrium tape, we need a way of blacklisting the tape.  Unfortunately,
the current blacklist mechanism is embedded in scsi_devinfo.c and isn't
amenable to modification. This patch series

1/3: Fixes the problem with devinfo so that the transport classes can
use it.  The interface is deliberately in scsi_priv.h so the hosts can't
use it

2/3: Updates some minor problems with the SPI transport class capability
code (instead of believing the inquiry data, it now believes only its
own settings)

3/3: Add the ultrium tape drives to the new blacklist code.

James


