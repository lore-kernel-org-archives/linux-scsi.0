From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [Fwd: tested your patch to gdth]
Date: Wed, 13 Feb 2008 10:32:45 +0200
Message-ID: <47B2AB2D.2040607@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:14438 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756110AbYBMIdD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2008 03:33:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tobias Oetiker <tobi@oetiker.ch>

I have received below message from a tester. Can any one please help me
with the /proc/scsi/gdth/0 problem. Where should I look?

Boaz 

On Wed, Feb 13 2008 at 8:39 +0200, Tobias Oetiker <tobi@oetiker.ch> wrote:
> Hi Boaz,
> 
> I just tested the patch to GDTH you published yesterday on LKML.
> With it I can boot of GDTH and things seem to work. Except when I
> do a cat to /proc/scsi/gdth/0 then the kernel panics and the
> machine reboots.
> 
> cheers
> tobi
> 

