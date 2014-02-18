From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 08/16] scsi_dh_alua: parse target device id
Date: Tue, 18 Feb 2014 08:26:55 +0100
Message-ID: <53030B3F.4010206@acm.org>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-9-git-send-email-hare@suse.de> <52FE0793.9040505@acm.org> <52FE0A66.6050200@suse.de> <5302171A.9070507@acm.org> <5302181A.9080308@suse.de> <53021C6B.7040207@acm.org> <53021DA9.9090408@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:57443 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751823AbaBRH1B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 02:27:01 -0500
In-Reply-To: <53021DA9.9090408@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 02/17/14 15:33, Hannes Reinecke wrote:
> On 02/17/2014 03:27 PM, Bart Van Assche wrote:
>> Updating VPD page 0x83 can be done easily for new FW releases. However,
>> the target identification approach explained in the previous e-mail is
>> already in use at several customer sites and I'm not sure it will be
>> possible to convince all of them to upgrade ...
>>
> Ok, fair enough.
> 
> Will be including it.

This has been discussed further internally. The outcome of the
discussion is that a target specific identifier will be added in the
Device Identification VPD page and also that we will take care of
upgrading the customer systems. In other words, no further action is
needed from your side. Sorry for the noise.

Bart.
