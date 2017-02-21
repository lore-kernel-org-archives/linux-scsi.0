From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCHv3] scsi: use 'scsi_device_from_queue()' for scsi_dh
Date: Tue, 21 Feb 2017 11:36:10 -0500
Message-ID: <CAMM=eLcYrcgyNd8gZPFx2T61+SSy_z_oa=AGt67PCYf=295ASQ@mail.gmail.com>
References: <1487318565-96759-1-git-send-email-hare@suse.de> <yq18tp0449t.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33608 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753921AbdBUQgm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2017 11:36:42 -0500
Received: by mail-lf0-f41.google.com with SMTP id l12so29656916lfe.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2017 08:36:36 -0800 (PST)
In-Reply-To: <yq18tp0449t.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>

On Mon, Feb 20, 2017 at 10:22 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:
>
> Hannes> The device handler needs to check if a given queue belongs to a
> Hannes> scsi device; only then does it make sense to attach a device
> Hannes> handler.
>
> Fixed kbuild warning and applied to 4.11/scsi-queue.

Thanks for picking this up but Keith's approach is slightly more
efficient and opens a way forward to expose support for both scsi_dh
and whatever Christoph is calling his NVMe device handler.  But we can
revisit once that latter lands.
