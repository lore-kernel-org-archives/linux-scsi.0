From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ses: Fix SAS device detection in enclosure
Date: Tue, 17 Jan 2017 06:47:54 -0800
Message-ID: <1484664474.2433.24.camel@HansenPartnership.com>
References: <1483997616-18900-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34508 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750995AbdAQOr4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Jan 2017 09:47:56 -0500
In-Reply-To: <1483997616-18900-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

On Mon, 2017-01-09 at 16:33 -0500, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
> 
> The call to scsi_is_sas_rphy() needs to be made on the
> SAS end_device, not on the SCSI device.
> 
> Fixes: 835831c57e9b ("ses: use scsi_is_sas_rphy instead of
> is_sas_attached")
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Yes, looks good to me as well

Reviewed-by: James Bottomley <James.Bottomley@HansenPartnership.com>


