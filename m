From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 08/16] scsi_dh_alua: parse target device id
Date: Mon, 17 Feb 2014 15:27:55 +0100
Message-ID: <53021C6B.7040207@acm.org>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-9-git-send-email-hare@suse.de> <52FE0793.9040505@acm.org> <52FE0A66.6050200@suse.de> <5302171A.9070507@acm.org> <5302181A.9080308@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:56262 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751487AbaBQO17 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Feb 2014 09:27:59 -0500
In-Reply-To: <5302181A.9080308@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 02/17/14 15:09, Hannes Reinecke wrote:
> If the product ID is actually the array identification and not a
> generic name, sure.
> But if all ION arrays with the same FW level identify itself with
> the same identifier it's kinda pointless :-)
> Otherwise, yeah, that's easily done.
> 
> But you might want to talk to your FW folks; if they were to update
> VPD page 0x83 to include an target-specific identifier we'd be all
> set ...

The product ID indeed identifies an array.

Updating VPD page 0x83 can be done easily for new FW releases. However,
the target identification approach explained in the previous e-mail is
already in use at several customer sites and I'm not sure it will be
possible to convince all of them to upgrade ...

Bart.

