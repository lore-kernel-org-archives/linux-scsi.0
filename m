From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 06/16] scsi_dh_alua: use local buffer for VPD inquiry
Date: Fri, 14 Feb 2014 12:41:47 +0100
Message-ID: <52FE00FB.7000103@acm.org>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:38963 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750862AbaBNLl4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Feb 2014 06:41:56 -0500
In-Reply-To: <1391160600-19652-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 01/31/14 10:29, Hannes Reinecke wrote:
> -	len = (h->buff[2] << 8) + h->buff[3] + 4;
> -	if (len > h->bufflen) {
> +	len = (buff[2] << 8) + buff[3] + 4;
> +	if (len > bufflen) {

I think this code will become easier to read when using
get_unaligned_be16() for extracting the length from the VPD response.

Bart.

