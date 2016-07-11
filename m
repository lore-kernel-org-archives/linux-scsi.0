From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] scsi: remove current_cmnd field from struct scsi_device
Date: Mon, 11 Jul 2016 13:56:31 +0200
Message-ID: <0f6adc94-88cf-3dcf-486e-b8a2233dd3ff@redhat.com>
References: <1468211695-11917-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbcGKL4d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2016 07:56:33 -0400
In-Reply-To: <1468211695-11917-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 11.7.2016 06:34, Christoph Hellwig wrote:
> The field is only used by the 53c700 driver, so move it into the
> driver-private device data instead of having it in the common structure.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

