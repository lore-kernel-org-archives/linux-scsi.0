From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: [PATCH 4/7] megaraid_sas: Send SYNCHRONIZE_CACHE command to firmware
Date: Wed, 26 Oct 2016 22:07:49 -0400
Message-ID: <yq1wpgu5ytm.fsf@sermon.lab.mkp.net>
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
        <yq1d1ip9oem.fsf@sermon.lab.mkp.net>
        <CAKiknE_MM88eVON1g_qy7wbb2fkxdAs6O0SRSzN-RbQqSvx1eA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mellowmood.mkp.net ([104.200.29.94]:46354 "EHLO
        mellowmood.mkp.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933693AbcJ0CHv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2016 22:07:51 -0400
In-Reply-To: <CAKiknE_MM88eVON1g_qy7wbb2fkxdAs6O0SRSzN-RbQqSvx1eA@mail.gmail.com>
        (=?utf-8?B?Ium7g+a4hemahiIncw==?= message of "Wed, 26 Oct 2016 16:20:55
 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Cc: Tomas Henzl <thenzl@redhat.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Ric Wheeler <rwheeler@redhat.com>, Hannes Reinecke <hare@suse.de>, Sumit Saxena <sumit.saxena@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>, Gris Ge <fge@redhat.com>, Ewan Milne <emilne@redhat.com>, Jens Axboe <axboe@kernel.dk>, RaghavaAditya.Renukunta@microsemi.com

>>>>> "ching" == 黃清隆  <ching2048@areca.com.tw> writes:

ching,

ching> Yes. Passing SYNCHRONIZE_CACHE command to firmware is safe for
ching> all Areca Raid controllers, even the oldest.

I applied your patch to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
