From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v5 0/7] ZBC / Zoned block device support
Date: Fri, 30 Sep 2016 11:47:53 -0500
Message-ID: <CAJVOszDkbr8-SezmuP+xH_HjOWeOm5FGNdKqjDBUCKq-B2-rJw@mail.gmail.com>
References: <1475208699-27310-1-git-send-email-damien.lemoal@hgst.com> <e00761c2-233f-0354-f150-305f38c6c294@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <e00761c2-233f-0354-f150-305f38c6c294@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Damien Le Moal <damien.lemoal@hgst.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>
List-Id: linux-scsi@vger.kernel.org

Hi Bart,

This series is against linux-next tag next-20160928.
You should be able to "git am" the series on top of that.

Thanks!
Shaun

On Fri, Sep 30, 2016 at 11:10 AM, Bart Van Assche
<bart.vanassche@sandisk.com> wrote:
> On 09/29/16 21:11, Damien Le Moal wrote:
>>
>> This series introduces support for zoned block devices.
>
>
> Hi Damien,
>
> On top of which kernel version do these patches apply? I tried to apply t=
he
> whole series to kernel v4.7 but that caused "git am" to complain ...
>
> Thank you,
>
> Bart.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at
> https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__vger.kernel.org_maj=
ordomo-2Dinfo.html&d=3DDQIC-g&c=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DWg5NqlNlVTT7Ug=
l8V50qIHLe856QW0qfG3WVYGOrWzA&m=3DVY30muznazMHPib_ks7gWROq97LIrq37TtKOXyYli=
B0&s=3Ds2DsgBOJACiLmv56Aw-uehcdexEfBe73hSnqZDfB0xY&e=3D



--=20
Shaun Tancheff
