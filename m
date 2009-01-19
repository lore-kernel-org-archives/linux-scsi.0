From: Gal Rosen <galr@storwize.com>
Subject: Virtual ports for AL topology
Date: Mon, 19 Jan 2009 13:12:44 +0200
Message-ID: <1232363564.29819.2.camel@galr-linux.storwiz.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.storwize.com ([62.90.10.208]:7442 "EHLO swdc2.storwiz.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752179AbZASLMy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2009 06:12:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Gal Rosen <galr@storwize.com>

Hi all,

I have modified qla2xxx code to support virtual ports in AL topology.
I am working with QLogic firmware that support MID.

The issue is that when I try to create couple of vports in sequence, on
mixed hosts, I get that some of the virtual ports created OK, and others
created but with vport_state failed or link down, and the result is that
I don't see all LUNs.

Another issue is that some of the LUNs that created, were created with
wrong host:channel:id:lun. If I created vport on physical hostX, then I
expected to see new hostY:0:0:0, and if there are more LUNs hostY:0:0:1,
and so on. But instead sometimes I get new vport on existing host but
with different id. For example hostX:0:1:0.

Does anyone have an idea for the wrong address ?
How the SCSI subsystem create the SCSI device address
host:channel:id:lun ?

Thanks,
Gal.
