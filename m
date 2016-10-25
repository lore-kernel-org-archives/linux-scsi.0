From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: [PATCH 4/7] megaraid_sas: Send SYNCHRONIZE_CACHE command to firmware
Date: Mon, 24 Oct 2016 22:02:25 -0400
Message-ID: <yq1d1ip9oem.fsf@sermon.lab.mkp.net>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
        <1476699850-25083-5-git-send-email-sumit.saxena@broadcom.com>
        <d9e79049-b4ce-588f-263d-dad015b3368d@suse.de>
        <9e5fbcef-bd72-71be-76f6-f41e26b5cb3c@redhat.com>
        <1476721205.2734.12.camel@linux.vnet.ibm.com>
        <14aa9905-b7fc-9695-dd19-1cc31cbee330@redhat.com>
        <1476724793.2734.21.camel@linux.vnet.ibm.com>
        <01e727ba166a34a97efdd5e890e4bc22@mail.gmail.com>
        <1476726692.2734.36.camel@linux.vnet.ibm.com>
        <b803c55c-23db-3bec-3d2f-58bc53d4ef37@redhat.com>
        <1476870626.11867.11.camel@Centos6.3-64>
        <5b6d87e8-c1ca-2d3f-cb0d-41df187103e9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mellowmood.mkp.net ([104.200.29.94]:45178 "EHLO
        mellowmood.mkp.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758090AbcJYCMK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2016 22:12:10 -0400
In-Reply-To: <5b6d87e8-c1ca-2d3f-cb0d-41df187103e9@redhat.com> (Tomas Henzl's
        message of "Wed, 19 Oct 2016 14:55:51 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Ching Huang <ching2048@areca.com.tw>, James Bottomley <jejb@linux.vnet.ibm.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Ric Wheeler <rwheeler@redhat.com>, Hannes Reinecke <hare@suse.de>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>, Gris Ge <fge@redhat.com>, Ewan Milne <emilne@redhat.com>, Jens Axboe <axboe@kernel.dk>, RaghavaAditya.Renukunta@microsemi.com

>>>>> "Tomas" == Tomas Henzl <thenzl@redhat.com> writes:

>> SCSI command checking in queuecommand function of arcmsr can be
>> removed safely.  Now driver can pass all scsi command to controller
>> firmware.

Tomas> Is this (passing the SYNCHRONIZE_CACHE command to firmware) safe
Tomas> for all arcmsr cards, even the oldest?

Ching?

-- 
Martin K. Petersen	Oracle Linux Engineering
