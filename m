From: "Seokmann Ju" <seokmann.ju@qlogic.com>
Subject: Question: vport_disable attribute under /sys/class/fc_vport
Date: Mon, 11 Jun 2007 10:05:46 -0700
Message-ID: <A6970E9A290F3F4682E1EAD0EA14F32B011417B7@AVEXCH2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:49419 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbXFKRG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jun 2007 13:06:27 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Duane Grigsby <duane.grigsby@qlogic.com>

Hello James,

I've got a question on NPIV framwork that is included in FC transport
layer. I'm using 2.6.22-rc3 with your NPIV-based vport patchset.
If I understood correctly, vport_disable and vport_delete attributes
have to be listed under /sys/class/fc_vport/vport-2:0-2/, once the
'vport-2:0-2' created successfully.
To make this happen, fc_function_template for the vport has modified to
add wrapper function for vport_disable and vport_delete in the driver.
However, in my result, I am only able to see vport_delete.
For some reason, vport_disable is not listed under the directory.

Can you please comment what possible reasons are there for this?

Thank you,

Seokmann
