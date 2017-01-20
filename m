From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH v2 2/4] mpt3sas: Fix for Crusader to achieve product
 targets with SAS devices.
Date: Fri, 20 Jan 2017 21:49:48 +0530
Message-ID: <CAK=zhgq_wWbaSN43+aDo0p7Soibssf5G3PVQecApHyiUTwN10A@mail.gmail.com>
References: <1484923333-8509-1-git-send-email-chaitra.basappa@broadcom.com>
 <1484923333-8509-3-git-send-email-chaitra.basappa@broadcom.com> <20170120150026.GA9315@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170120150026.GA9315@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Krishnaraddi Mankani <krishnaraddi.mankani@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 20, 2017 at 8:30 PM, Johannes Thumshirn <jthumshirn@suse.de> wr=
ote:
> On Fri, Jan 20, 2017 at 08:12:11PM +0530, Chaitra P B wrote:
>> Small glitch/degraded performance in Crusader is improved with SAS
>> drives by removing unnecessary spinlocks while clearing scsi command
>> in drivers internal lookup table.
>>
>> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
>> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
>> ---
>
> Whats wrong with creating a __scsih_scsi_lookup_get_clear() and calling
> it with the scsi_lookup_lock held from _scsih_scsi_lookup_get_clear()
> instead of duplicating the code?
>
> It's quite common in the linux kernel to have two functions func and __fu=
nc,
> where func is
>
> func()
> {
>         spin_lock();
>         __func();
>         spin_unlock();
> }
>

Sure, We will resend this path with this change.

Thanks,
Sreekanth

> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
