From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 3/3] megaraid_sas: use dev_printk when possible
Date: Tue, 5 May 2015 13:30:19 -0500
Message-ID: <CAErSpo5bmtbq_ji8OM4_fbz4ix1xLw2LUD6tbdr0jKNSzN5xyw@mail.gmail.com>
References: <20150428231312.10378.49039.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <20150428231417.10378.97464.stgit@bhelgaas-glaptop2.roam.corp.google.com> <3a237529c12b20e6b7a4c8de82b6a3ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3a237529c12b20e6b7a4c8de82b6a3ee@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 29, 2015 at 12:44 AM, Sumit Saxena
<sumit.saxena@avagotech.com> wrote:
>>-----Original Message-----
>>From: Bjorn Helgaas [mailto:bhelgaas@google.com]
>>Sent: Wednesday, April 29, 2015 4:44 AM
>>To: Kashyap Desai; Uday Lingala; Sumit Saxena
>>Cc: megaraidlinux.pdl@avagotech.com; James E.J. Bottomley; linux-
>>kernel@vger.kernel.org; linux-scsi@vger.kernel.org
>>Subject: [PATCH 3/3] megaraid_sas: use dev_printk when possible
>>
>>Use dev_printk() when possible to make messages more useful.
>> ...

> Currently few patches are sent for megaraid_sas driver and after applying
> those patches, this patch may not apply cleanly. Once those patches are
> accepted, I will rebase and send this patch again.

OK, sure.  Do you want me to repost these after your patches get
merged somewhere?

Bjorn
