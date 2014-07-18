From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] virtio_scsi: check on resp->sense_len instead of 'sense_buffer'
Date: Fri, 18 Jul 2014 23:09:41 +0800
Message-ID: <CACVXFVPV2m4-ZNyE3x6zTeN86PkhX8KEd5-47ntGn7mzrJTHOA@mail.gmail.com>
References: <1405695438-18485-1-git-send-email-ming.lei@canonical.com>
	<53C93672.8030805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46050 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618AbaGRPJo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jul 2014 11:09:44 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44])
	by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.71)
	(envelope-from <ming.lei@canonical.com>)
	id 1X89n5-0001Sz-0Z
	for linux-scsi@vger.kernel.org; Fri, 18 Jul 2014 15:09:43 +0000
Received: by mail-oi0-f44.google.com with SMTP id x69so1952593oia.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2014 08:09:41 -0700 (PDT)
In-Reply-To: <53C93672.8030805@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Fri, Jul 18, 2014 at 11:00 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 18/07/2014 16:57, Ming Lei ha scritto:
>> -     if (sc->sense_buffer) {
>> +     if (resp->sense_len) {
>
> In the (unlikely) case that sc->sense_buffer == NULL, you'd pass a NULL
> to memcpy.

Every valid scsi_cmnd should have non NULL sc->sense_buffer, please
see scsi_host_alloc_command().

Thanks,
--
Ming Lei
